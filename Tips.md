* Tips to start a new project

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

run yur app with rack but perhaps not using puma as server
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

to execute a task,
rake db:load_earthquakes
the "namespace :db" its only to organize the task when exists many, its not necessary to use a "namespace :x" but its a good practice
