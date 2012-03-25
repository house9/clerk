module Clerk
  class Callback
    def before_create(record)
      record.creator = current_user if record.respond_to?(:creator) && current_user
      record.updater = current_user if record.respond_to?(:updater) && current_user
    end
  
    def before_update(record)
      record.updater = current_user if record.respond_to?(:updater) && current_user
    end
    
    # relies on `include SentientUser` on User
    def current_user
      logger.warn "WARNING: User#current is not defined, are you including SentientUser on your User model?" unless User.respond_to?(:current)
      logger.warn "WARNING: User#current is nil, are you including SentientUser on your ApplicationController?" unless User.current

      User.current
    end  
    
    def logger
      Rails.logger
    end
  end
end