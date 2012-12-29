class Post < ActiveRecord::Base

end

class User < ActiveRecord::Base
  include SentientUser
end

class Foo < ActiveRecord::Base

end