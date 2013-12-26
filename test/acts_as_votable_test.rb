require 'test_helper'

class ActsAsVotableTest < ActiveSupport::TestCase
  setup do
    3.times do |i|
      User.create(name: "user#{i+1}")
    end
    3.times do |i|
      Post.create(title: "post title #{i+1}", user: User.all[i])
    end
  end

  test "truth" do
    assert_kind_of Module, ActsAsVotable
  end

  test "module 'ActsAsVotable' is existed" do
    assert_kind_of Module, ActsAsVotable
  end

  test "acts_as_voter method is available" do
    assert User.respond_to? :acts_as_voter
    assert User.respond_to? :acts_as_voter_on
  end

  test "acts_as_votable method is available" do
    assert Post.respond_to? :acts_as_votable
    assert Post.respond_to? :acts_as_votable_by
  end

  test "vote?/vote/unvote methods are available" do
    user = User.first
    assert user.respond_to? :vote?
    assert user.respond_to? :vote
    assert user.respond_to? :unvote
  end

  test "vote_by?/vote_by/unvote_by methods are available" do
    post = Post.first
    assert post.respond_to? :vote_by?
    assert post.respond_to? :vote_by
    assert post.respond_to? :unvote_by
  end

  test "method 'acts_as_voter' is available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal(false, user1.vote?(post1, 'voteup'))
    user1.vote(post1, 'voteup', post1.user)
    assert_equal(true, user1.vote?(post1, 'voteup'))
    assert_equal 1, user1.votes.count

    user1.unvote(post1, 'voteup')
    assert_equal(false, user1.vote?(post1, 'voteup'))

    assert_equal(false, user1.vote?(post2, 'votedown'))
    user1.vote(post2, 'votedown', post2.user)
    assert_equal(true, user1.vote?(post2, 'votedown'))
    assert_equal 1, user1.votes.count

    assert_equal 1, ActsAsVotable::Vote.all.count

  # user1.unvote(post2, nil)
    user1.unvote(post2, ['voteup', 'votedown'])
    assert_equal 0, user1.votes.count
    assert_equal 0, ActsAsVotable::Vote.all.count
  end

  test "method 'acts_as_votable' is available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal(false, post1.vote_by?(user1, 'voteup'))
    post1.vote_by(user1, 'voteup', post1.user)
    assert_equal(true, post1.vote_by?(user1, 'voteup'))
    assert_equal 1, post1.votes.count

    post1.unvote_by(user1, 'voteup')
    assert_equal(false, post1.vote_by?(user1, 'voteup'))

    assert_equal(false, post1.vote_by?(user2, 'votedown'))
    post1.vote_by(user2, 'votedown', post2.user)
    assert_equal(true, post1.vote_by?(user2, 'votedown'))
    assert_equal 1, post1.votes.count

    assert_equal 1, ActsAsVotable::Vote.all.count

    post1.unvote_by(user2, nil)
    assert_equal 0, post1.votes.count
    assert_equal 0, ActsAsVotable::Vote.all.count
  end

  test "method 'acts_as_voter_on' is available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal 0, user1.voteup_posts_votes.count
    assert_equal 0, user1.voteup_posts.count
    user1.vote(post1, 'voteup', post1.user)
    assert_equal 1, user1.votes.where(action: 'voteup').size
    assert_equal 1, user1.voteup_posts_votes.count
    assert_equal 1, user1.voteup_posts.count

    assert_equal 0, user1.votedown_posts_votes.count
    assert_equal 0, user1.votedown_posts.count
    user1.vote(post1, 'votedown', post1.user)
    assert_equal 1, user1.votes.where(action: 'votedown').size
    assert_equal 1, user1.votedown_posts_votes.count
    assert_equal 1, user1.votedown_posts.count

    assert_equal 2, user1.votes.size
  end

  test "method 'acts_as_votable_by' is available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal 0, post1.voteup_users_votes.count
    assert_equal 0, post1.voteup_users.count
    post1.vote_by(user1, 'voteup', post1.user)
    assert_equal 1, post1.votes.where(action: 'voteup').size
    assert_equal 1, post1.voteup_users_votes.count
    assert_equal 1, post1.voteup_users.count

    assert_equal 0, post1.votedown_users_votes.count
    assert_equal 0, post1.votedown_users.count
    post1.vote_by(user1, 'votedown', post1.user)
    assert_equal 1, post1.votes.where(action: 'votedown').size
    assert_equal 1, post1.votedown_users_votes.count
    assert_equal 1, post1.votedown_users.count

    assert_equal 2, post1.votes.size
  end

  test "generated methods by 'acts_as_voter_on' are available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal 0, user1.voteup_posts_votes.count
    assert_equal 0, user1.voteup_posts.count

    assert_equal false, user1.voteup?(post1)
    user1.voteup(post1, post1.user)
    assert_equal true, user1.voteup?(post1)

    user1.voteup(post2, post1.user)
    assert_equal 2, user1.votes.where(action: 'voteup').size
    assert_equal 2, user1.voteup_posts_votes.count
    assert_equal 2, user1.voteup_posts.count

    user1.unvoteup(post2)
    assert_equal 1, user1.votes.where(action: 'voteup').size
    assert_equal 1, user1.voteup_posts_votes.count
    assert_equal 1, user1.voteup_posts.count

    assert_equal 0, user1.votedown_posts_votes.count
    assert_equal 0, user1.votedown_posts.count

    user1.votedown(post1, post1.user)
    assert_equal 1, user1.votes.where(action: 'votedown').size
    assert_equal 1, user1.votedown_posts_votes.count
    assert_equal 1, user1.votedown_posts.count

    assert_equal 2, user1.votes.size
  end

  test "generated methods 'acts_as_votable_by' are available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal 0, post1.voteup_users_votes.count
    assert_equal 0, post1.voteup_users.count

    assert_equal false, post1.voteup_by?(user1)
    post1.voteup_by user1, post1.user
    assert_equal true, post1.voteup_by?(user1)

    assert_equal 1, post1.votes.where(action: 'voteup').size
    assert_equal 1, post1.voteup_users_votes.count
    assert_equal 1, post1.voteup_users.count

    post1.unvoteup_by user1
    assert_equal false, post1.voteup_by?(user1)

    assert_equal 0, post1.votedown_users_votes.count
    assert_equal 0, post1.votedown_users.count
    post1.vote_by(user1, 'votedown', post1.user)
    assert_equal 1, post1.votes.where(action: 'votedown').size
    assert_equal 1, post1.votedown_users_votes.count
    assert_equal 1, post1.votedown_users.count

    assert_equal 1, post1.votes.size
  end
end
