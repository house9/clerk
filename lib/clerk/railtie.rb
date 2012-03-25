require 'clerk'
require 'rails/railtie'

module Clerk
  class Railtie < Rails::Railtie
    initializer 'clerk.ar_extensions' do |app|
      ActiveRecord::Base.extend Clerk
    end
  end
end