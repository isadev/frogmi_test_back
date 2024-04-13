require 'rails'

module DatabaseInitializer
  class Railtie < Rails::Railtie
    initializer 'database_initializer.connect' do
      ActiveSupport.on_load :active_record do
        config = Rails.application.config.database_configuration[Rails.env]
        ActiveRecord::Base.establish_connection(config)
      end
    end
  end
end