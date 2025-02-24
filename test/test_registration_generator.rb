# frozen_string_literal: true
require "test_helper"
require "rails/generators"
require "generators/authentication_with_registration/authentication_with_registration_generator"

class TestAuthenticationWithRegistrationGenerator < Minitest::Test
  tests AuthenticationWithRegistration::AuthenticationWithRegistration
  destination File.expand_path("../../tmp", __dir__)  # Isolated test directory
  setup :prepare_destination

  def test_auth_generator_invocation
    authentication_file = File.join(destination_root, "app/controllers/concerns/authentication.rb")

    FileUtils.mkdir_p(File.dirname(authentication_file)) # Create parent directory

    # Case 1: If file does not exist, generator should be invoked
    File.delete(authentication_file) if File.exist?(authentication_file) 
    run_generator
    assert File.exist?(authentication_file), "Expected authentication.rb to be created"

    # Case 2: If file already exists, generator should NOT be invoked again
    File.write(authentication_file, "module Authentication\nend") # Fake existing file
    output = run_generator
    refute_match(/invoke.*rails:authentication/, output, "rails:authentication should not run when file exists")
  end

  def test_views_are_created
    run_generator
    assert_file "app/views/registrations/new.html.erb"
    assert_file "app/views/sessions/new.html.erb"
  end

  def test_controller_is_created
    run_generator
    assert_file "app/controllers/registrations_controller.rb"
  end

  def test_routes_are_added
    run_generator
    assert_file "config/routes.rb", /resource :registration, only: \[:new, :create\]/
    assert_file "config/routes.rb", /get "sign_in", to: "sessions#new", as: :sign_in/
    assert_file "config/routes.rb", /delete "sign_out", to: "sessions#destroy", as: :sign_out/
  end

  def test_authentication_concern_is_updated
    auth_path = "app/controllers/concerns/authentication.rb"

    run_generator

    assert_file auth_path, /def link_to_sign_in_or_out/
    assert_file auth_path, /helper_method :link_to_sign_in_or_out, :show_user_if_signed_in/
  end
end

