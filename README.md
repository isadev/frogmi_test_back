# README

This README document steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

        ruby 3.0.0p0 (2020-12-25 revision 95aff21468)

- System dependencies

        None

- Configuration
-       Not needed

- Database creation

        Not needed this project work with migrations

- Database initialization

        rails db:migrate

- How to run the test suite

        Not added yet

- Deployment instructions (in this order):

        bundle install

        rake db:load_earthquakes

        rackup -p 3000

- **CAUTION**

The port can be change, but the front side must exist in the port 3001
Cors are activated and this project only accept request from http://localhost:3001
If the frontend port has to be changed, go to this file:

        config/initializers/cors.rb
