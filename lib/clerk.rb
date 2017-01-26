require 'active_record'
require 'sentient_user'
require 'clerk/version'
require 'clerk/configuration'
require 'clerk/callback'
require 'clerk/railtie'

module Clerk
  def track_who_does_it(options = {})
    before_create Clerk::Callback.new
    before_update Clerk::Callback.new

    creator_fk = options.fetch(:creator_foreign_key) { "created_by_id" }
    updater_fk = options.fetch(:updater_foreign_key) { "updated_by_id" }

    belongs_to :creator, :class_name => "User", :foreign_key => creator_fk
    belongs_to :updater, :class_name => "User", :foreign_key => updater_fk
  end
end
