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
FactoryBot.build(:model)
rails g serializer <model>                                  # Creates a serializer for the model

# Modifications
user = <%= Rails.application.credentials[:DB_USER] %>       # This is going to take the credentials from the encrypted file
password = <%= Rails.application.credentials[:DB_PASS] %>   # This is going to take the credentials from the encrypted file

