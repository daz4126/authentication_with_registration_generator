# lib/registration_generator/generators/registration/registration_generator.rb
require "rails/generators"
require "registration_generator/generators/registration/registration_generator"

module RegistrationGenerator
  class RegistrationGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def create_view
      template 'registration_form.html.erb', "app/views/registrations/new.html.erb"
    end

    def create_sign_in
      template 'sign_in_form.html.erb', "app/views/sessions/new.html.erb", force: true
    end

    def create_controller
      template 'registrations_controller.rb', "app/controllers/registrations_controller.rb"
    end

    def add_routes
      route "resource :registration, only: [:new, :create]"
    end
  end
end
