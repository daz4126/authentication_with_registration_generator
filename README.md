# RegistrationGenerator

A Rails Generator that adds registration pages to the Authentication Generator as well as some useful routes and helper methods.

* Adds a registration page which will create a new user with an email address and password.
* Adds `new_registration_path` and `registration_path` routes
* Adds a registration link on the sign_in page
* Adds '/sign_in' and '/sign_out' routes as alias to '/session/new' and 'session', these can be accessed using the `sign_in_path` and `sign_out_path, method: :delete` helpers
* Adds a `link_to_sign_in_or_out` helper that will display a sign out or sign in link depending on if a user is authenticated or not
* Adds a `show_username_if_signed_in` method that displays a "signed in as username" message if the user is signed in
* Adds a `name` method to the user model that is an alias for the email_address, but can be changed

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add registration_generator

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install registration_generator

## Usage

TODO: Write usage instructions hereRun the authentication generator first:

```bash
rails generate authentication
```

Then run the registration generator:

```bash
rails generate registration
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/daz4126/registration_generator.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
