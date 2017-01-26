# Clerk

[![Build Status](https://travis-ci.org/house9/clerk.png)](https://travis-ci.org/house9/clerk) [![Code Climate](https://codeclimate.com/github/house9/clerk.png)](https://codeclimate.com/github/house9/clerk)

Clerk adds the following attributes to your ActiveRecord objects

* creator
* updater

Used in conjunction with the [`sentient_user`](https://github.com/bokmann/sentient_user) gem,
Clerk will automatically update these attributes using `before_create` and `before_update`
ActiveRecord callback methods

The gem assumes the following:

* you have a User model
* you have a `current_user` method on your ApplicationController
* you have 2 columns which are foreign keys of users.id
  * the gems uses the following as defaults `created_by_id` and `updated_by_id`

## Installation

Add this line to your application's Gemfile:

    gem 'clerk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clerk

Then follow the directions under Setup

### Version Notes

* Use `0.2.x` for rails 4
* Use `0.3.x` for rails 5

## Setup

Step 1: include the `sentient_user` SentientUser module on your User `/app/models/user.rb`

    class User < ActiveRecord::Base
      include SentientUser
    endis

Step 2: include the `sentient_user` SentientController module on your ApplicationController `/app/controllers/application_controller.rb`

    class ApplicationController < ActionController::Base
      protect_from_forgery
      include SentientController

      # ...
    end

Step 3: Add the `track_who_does_it` macro to any ActiveRecord models that have `created_by_id` and `updated_by_id` database columns

    class Post < ActiveRecord::Base
      track_who_does_it
    end

We probably want our User model to `track_who_does_it` as well

    class User < ActiveRecord::Base
      include SentientUser
      track_who_does_it
    end

You can optionally override the default column names `created_by_id` and `updated_by_id`

    class Post < ActiveRecord::Base
      track_who_does_it :creator_foreign_key => "user_id", :updater_foreign_key => "updater_id"
    end

## Usage

Once you have finished the Setup and restarted your rails server
your models should automatically update the creator and the updater attributes after being saved.

Since your models have the creator and updater attributes you can display these in any views

    Updated by <%= @post.updater.full_name %> at <%= l(@post.updated_at, :format => :long) %>

Since we are using `sentient_user` you can also set the updater or creator in tests or rake tasks

    user = User.find(5150)
    user.make_current # now all models marked as track_who_does_it will save with this user tracked
    Post.create!(:title => "New Post")
    Post.last.creator == user # => true

## Configuration

In case you need to customize Clerk. Just create `config/initializers/clerk.rb` and set up your configuration:

```ruby
Clerk.configure do |config|
  config.silence_warnings = true | false     # Defaults: false (true in test env)
  config.logger = MyCustomLogger.new()       # Defaults: Rails.logger
end
```


## Resources used in the development of this gem

* [http://ryanbigg.com/2011/01/extending-active-record/](http://ryanbigg.com/2011/01/extending-active-record/)
* [http://charlotteruby.org/gem_workshop_tutorial/](http://charlotteruby.org/gem_workshop_tutorial/)
* [http://yehudakatz.com/2009/11/12/better-ruby-idioms/](http://yehudakatz.com/2009/11/12/better-ruby-idioms/)
* [http://www.cowboycoded.com/2011/01/31/developing-is_able-or-acts_as-plugins-for-rails/](http://www.cowboycoded.com/2011/01/31/developing-is_able-or-acts_as-plugins-for-rails/)
* [http://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html](http://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html)
* [https://github.com/bokmann/sentient_user](https://github.com/bokmann/sentient_user)
* [https://robots.thoughtbot.com/mygem-configure-block](https://robots.thoughtbot.com/mygem-configure-block)
