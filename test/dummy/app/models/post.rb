class Post < ActiveRecord::Base
  belongs_to :user
  acts_as_votable
  acts_as_votable_by :voteup_users
  acts_as_votable_by :votedown_users
  acts_as_votable_by :accept
end
