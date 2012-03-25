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
end