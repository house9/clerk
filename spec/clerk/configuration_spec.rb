require 'spec_helper'

describe Clerk::Configuration do
  before(:each) do
    # Setups configuration
    Clerk.configure {}
  end
  after(:each) do
    # Reset configuration
    Clerk.configuration = Clerk::Configuration.new
  end
  it "should have a configuration" do
    Clerk.configuration.should be_a(Clerk::Configuration)
  end

  context 'silence_warnings' do
    it 'should be false by default' do
      Clerk.configuration.silence_warnings.should be_false
    end

    it 'can be toggled to true' do
      Clerk.configure { |c| c.silence_warnings = true }
      Clerk.configuration.silence_warnings.should be_true
    end
  end

  context 'logger' do
    it 'should exist by default' do
      Clerk.configuration.logger.should be_a ActiveSupport::Logger
    end

    it 'should be configurable' do
      class FakeLogger
        def warn(msg)
          # noop
        end
      end

      Clerk.configure { |c| c.logger = FakeLogger.new() }

      Clerk.configuration.logger.should be_a FakeLogger
    end
  end
end