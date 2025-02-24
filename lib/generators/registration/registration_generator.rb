# lib/generators/registration/registration_generator.rb
require "rails/generators"

module Registration
  class RegistrationGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def run_auth_generator
      invoke "rails:authentication"
    end

    def create_view
      template "registration_form.html.erb", "app/views/registrations/new.html.erb"
    end

    def create_sign_in
      template "sign_in_form.html.erb", "app/views/sessions/new.html.erb", force: true
    end

    def create_controller
      template "registrations_controller.rb", "app/controllers/registrations_controller.rb"
    end

    def add_routes
      route "resource :registration, only: [:new, :create]"
      route "get \"sign_in\", to: \"sessions#new\", as: :sign_in"
      route "delete \"sign_out\", to: \"sessions#destroy\", as: :sign_out"
    end
    
    def update_authentication_concern
      inject_into_file "app/controllers/concerns/authentication.rb", before: "private\n" do
        <<~RUBY
    
          def link_to_sign_in_or_out
            if authenticated?
              button_to "Sign Out", sign_out_path, method: :delete
            else
              link_to "Sign In", sign_in_path
            end
          end
    
          def show_user_if_signed_in
            if authenticated?
              "Signed in as \#{Current.user.email_address}"
            end
          end
        RUBY
      end
    end
  end
end