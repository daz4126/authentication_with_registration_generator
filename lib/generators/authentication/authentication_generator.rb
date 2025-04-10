# lib/generators/registration/registration_generator.rb
require "rails/generators"

module Authentication
  class Authentication < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def run_auth_generator
      unless File.exist?(Rails.root.join("app/controllers/concerns/authentication.rb"))
        invoke "rails:authentication"
      end
    end

    def add_uniqueness_validation
      user_model_path = "app/models/user.rb"
  
      # Check if the validation already exists to prevent duplication
      if File.exist?(user_model_path)
        if File.readlines(user_model_path).grep(/validates.*:email_address.*uniqueness/).empty?
          inject_into_class user_model_path, "User", "  validates :email_address, uniqueness: true\n"
        end
      end
    end

    def create_view
      template "registration_form.html.erb", "app/views/registrations/new.html.erb"
    end

    def create_controller
      template "registrations_controller.rb", "app/controllers/registrations_controller.rb"
    end

    def add_routes
      route "resource :registration, only: [:new, :create]"
      route "get \"sign_in\", to: \"sessions#new\", as: :sign_in"
      route "delete \"sign_out\", to: \"sessions#destroy\", as: :sign_out"
    end

    def modify_session_view
      # Path to the generated sessions/new.html.erb
      session_view_path = "app/views/sessions/new.html.erb"
  
      # Check if the file exists before modifying it
      if File.exist?(session_view_path)
        # Replace the "Forgot password?" link with the new links
        gsub_file session_view_path, /<br>\s*<%= link_to "Forgot password\?", new_password_path %>/ do |match|
          "<p>\n  <%= link_to 'Forgot password?', new_password_path %> | \n  <%= link_to 'No Account? Register here', new_registration_path %>\n</p>"
        end
      else
        # If the file doesn't exist, handle it accordingly (e.g., raise an error or create the file)
        raise "Session view file not found"
      end
    end
    
    def update_authentication_concern
      inject_into_file "app/controllers/concerns/authentication.rb", before: "private\n" do
        <<~RUBY
    
          def link_to_sign_in_or_out
            if authenticated?
              # Return the form as a string
              "<form class=\\"button_to\\" action=\\"\#{sign_out_path}\\" accept-charset=\\"UTF-8\\" method=\\"post\\">
                <input type=\\"hidden\\" name=\\"_method\\" value=\\"delete\\" autocomplete=\\"off\\" />
                <button type=\\"submit\\">Sign Out</button>
                <input type=\\"hidden\\" name=\\"authenticity_token\\" value=\\"\#{form_authenticity_token}\\" autocomplete=\\"off\\" />
              </form>".html_safe
            else
              "<a href=\\"\#{sign_in_path}\\">Sign In</a>".html_safe
            end
          end 
    
          def show_user_if_signed_in
            if authenticated?
              "Signed in as \#{Current.user.email_address}"
            end
          end
          
        RUBY
      end
    
      inject_into_file "app/controllers/concerns/authentication.rb", after: ":authenticated?" do
        ", :link_to_sign_in_or_out, :show_user_if_signed_in"
      end
    end
    
  end
end