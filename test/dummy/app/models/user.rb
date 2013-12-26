class User < ActiveRecord::Base
  has_many :posts
  acts_as_voter
  acts_as_voter_on :voteup_posts
  acts_as_voter_on :votedown_posts
end
