# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

CAUTION:
the folder tmp pids have to exist always to let puma run

creation of ruby app:
rails new frogmi-api-project --api

download new libs/module
gem install x

install lib
bundle install

execute a ruby console with rails
rails c

run your app in rails without rack
rails server

run yur app with rack but not using puma as server
rackup -p 3000

generate migration to ddbb
rails generate model <model> <attr_name>:<data_type>
example
rails generate model Earthquake id:string external_id:string magnitude:float place:string time:string tsunami:boolean mag_type:string title:string longitude:float latitude:float

execute migration
rails db:migrate

back a migration
rails db:rollback

the foreign key are handled like any other orm with the relations of belongs_to o has_many an so on, the only thing to do is to join both tables with the same name of the foreign_key
