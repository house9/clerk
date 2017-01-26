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
      warn "User#current is not defined, are you including SentientUser on your User model?" unless User.respond_to?(:current)
      warn "User#current is nil, are you including SentientController on your ApplicationController?" unless User.current

      User.current
    end

    #######
    private
    #######

    def warn(message)
      logger.warn "WARNING: #{message}" unless configuration.silence_warnings
    end

    def logger
      configuration.logger
    end

    def configuration
      Clerk.configuration
    end
  end
end