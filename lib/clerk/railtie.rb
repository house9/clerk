require 'clerk'
require 'rails/railtie'

module Clerk
  class Railtie < Rails::Railtie
    initializer 'clerk.ar_extensions' do |app|
      ActiveRecord::Base.extend Clerk

      #initialize configuration object
      Clerk.configure do |config|
        config.logger = Rails.logger
      end
    end
  end
end