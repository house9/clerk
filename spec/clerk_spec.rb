require 'spec_helper'

describe Clerk do
  it "should have a version" do
    Clerk::VERSION.length.should > 0
  end

  it "should expose track_who_does_it" do
    Post.extend Clerk
    Post.should respond_to :track_who_does_it
  end

  describe "extended objects" do
    Post.extend Clerk

    class PostExtended < Post
      track_who_does_it
    end

    it "should respond to creator" do
      post = PostExtended.new
      post.should respond_to :creator
    end

    it "should respond to updater" do
      post = PostExtended.new
      post.should respond_to :updater
    end
  end

  describe "clerical objects can be tracked automatically" do
    Post.extend Clerk

    class PostExtended < Post
      track_who_does_it
    end

    before(:each) do
      @creator = User.create!(:name => "creator")
      @updater = User.create!(:name => "updater")
    end

    it "by creator" do
      @creator.make_current
      this = PostExtended.new(:title => "Test")
      this.save
      this.creator.name.should == "creator"
      this.updater.name.should == "creator"
    end

    it "by updater" do
      @creator.make_current
      this = PostExtended.new(:title => "Test2")
      this.save

      @updater.make_current
      this.update_attribute(:title, "Updated")
      this.creator.name.should == "creator"
      this.updater.name.should == "updater"
    end
  end

  describe "specified foreign_keys" do
    Foo.extend Clerk

    class FooExtended < Foo
      track_who_does_it :creator_foreign_key => "user_id", :updater_foreign_key => "updater_id"
    end

    it "can override default foreign_keys" do
      creator = User.create!(:name => "creator")
      creator.make_current
      this = FooExtended.new(:bar => "Test")
      this.save
      this.creator.name.should == "creator"
      this.updater.name.should == "creator"
    end
  end

  describe "warning messages" do
    Post.extend Clerk

    class PostExtended < Post
      track_who_does_it
    end

    before(:each) do
      @logger = double("logger", warn: true)
      Clerk.configure { |c| c.logger = @logger }
    end

    after(:each) do
      # Reset configuration
      Clerk.configuration = Clerk::Configuration.new
    end

    context "when missing SentientUser" do
      before do
        User.stub(:respond_to?).with(:current).and_return(false)
      end
      it "should log a message" do
        @logger.should_receive(:warn).with("WARNING: User#current is not defined, are you including SentientUser on your User model?")
        this = FooExtended.new(:bar => "Test")
        this.save
      end

      context "amd warning are silenced" do
        before do
          Clerk.configure { |c| c.silence_warnings = true }
        end

        it "should not show a log message" do
          @logger.should_not_receive(:warn).with("WARNING: User#current is not defined, are you including SentientUser on your User model?")
          this = FooExtended.new(:bar => "Test")
          this.save
        end
      end
    end

    context "when missing User.current" do
      before do
        User.current = nil
      end

      it "should log a message" do
        @logger.should_receive(:warn).with("WARNING: User#current is nil, are you including SentientController on your ApplicationController?")
        this = FooExtended.new(:bar => "Test")
        this.save
      end

      context "amd warning are silenced" do
        before do
          Clerk.configure { |c| c.silence_warnings = true }
        end

        it "should not show a log message" do
          @logger.should_not_receive(:warn).with("WARNING: User#current is nil, are you including SentientController on your ApplicationController?")
          this = FooExtended.new(:bar => "Test")
          this.save
        end
      end
    end
  end
end