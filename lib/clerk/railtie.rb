require 'clerk'
require 'rails/railtie'

module Clerk
  class Railtie < Rails::Railtie
    initializer 'clerk.ar_extensions' do |app|
      ActiveRecord::Base.extend Clerk

      Clerk.configure do |config|
        config.silence_warnings = Rails.env.test?
        config.logger = Rails.logger
      end
    end
  end
end