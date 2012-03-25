require 'spec_helper'

describe Clerk do
  it "should have a version" do
    Clerk::VERSION.length.should > 0
  end

  it "should make is_clerical available" do
    Post.extend Clerk
    Post.should respond_to :is_clerical
  end
  
  describe "extended objects" do
    Post.extend Clerk
    
    class PostExtended < Post
      is_clerical
    end
        
    it "should have creator" do
      post = PostExtended.new
      post.should respond_to :creator
    end
    
    it "should have updater" do
      post = PostExtended.new
      post.should respond_to :updater
    end    
  end
  
end