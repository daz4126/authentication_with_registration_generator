# lib/generators/registration/registration_generator.rb
require "rails/generators"

module Registration
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
      route "get 'sign_in', to: 'session#new', as :sign_in"
      route "delete 'sign_out', to: 'session#destroy', as :sign_out"
    end
    
    def create_helper
      create_file "app/helpers/authentication_helper.rb", <<-RUBY
      module AuthenticationHelper
        def link_to_sign_in_or_out(show_user: false)
          if authenticated?
            button_to "Sign Out", sign_out_path, method: :delete
          else
            link_to "Sign In", sign_in_path
          end
        end

        def show_username_if_signed_in(text="Signed in as")
          if authenticated?
            content = "#{text} #{Current.user.name}"
            content.html_safe
          end
        end
      end
      RUBY
    
      inject_into_class "app/controllers/application_controller.rb", ApplicationController, <<-RUBY
    
      include AuthenticationHelper
      RUBY
    end

    def add_name_method_to_user
      inject_into_class "app/models/user.rb", User, <<-RUBY
    
      def name
        email_address
      end
    
      RUBY
    end
  end
end
