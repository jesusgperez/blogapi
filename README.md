# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Commands
rails new blogapi --api -T --database postgresql            # A new flag to specify that we are going to create just an API
EDITOR=vim rails credentials:edit                           # Edits the encrypted credentials
rails db:create                                             # Create databases in the database engine
rails generate rspec:install                                # Installs the necessary files for testing
rails destroy model post                                    # Destroys a generated model
rails g factory_bot:model user email:string name:string auth_token:string   # Creates a factory bot for the specified model
RAILS_ENV=test rails c                                      # Access the console from another environment
FactoryBot.build(:model)                                    # Creates a fake instance of the specified model
rails g serializer <model>                                  # Creates a serializer for the model
bundle exec rspec path/to/file.rb:29                        # Executes just a single test
tail -f log/test.log                                        # Follows logs, in this case database queries
curl localhost:3000/health | jq .                           # Formats the json in the console
rails g job post_report                                     # Generates a job to be executed in background
rails g mailer post_report                                  # Generates a mailer struc for the reports

# Modifications
user = <%= Rails.application.credentials[:DB_USER] %>       # This is going to take the credentials from the encrypted file
password = <%= Rails.application.credentials[:DB_PASS] %>   # This is going to take the credentials from the encrypted file
