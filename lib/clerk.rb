require 'active_record'
require 'sentient_user'
require 'clerk/version'
require 'clerk/callback'
require 'clerk/railtie'

module Clerk
  def is_clerical
    before_create Clerk::Callback.new
    before_update Clerk::Callback.new

    belongs_to :creator, :class_name => "User", :foreign_key => "created_by_id"
    belongs_to :updater, :class_name => "User", :foreign_key => "updated_by_id"
  end
end
