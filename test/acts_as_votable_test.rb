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

  test "vote?/vote/unvote methods work" do
    user1, user2, user3 = User.all[0], User.all[1], User.all[2];
    post1, post2, post3 = Post.all[0], Post.all[1], Post.all[2];

    # vote?
    assert_equal(false, user1.vote?(post1, 'voteup'))
    assert_equal(false, user1.vote?(post1, 'votedown'))

    # vote
    user1.vote post1, 'voteup', post1.user
    user1.vote post1, 'votedown', post1.user
    assert_equal(true,  user1.vote?(post1, 'voteup'))
    assert_equal(true,  user1.vote?(post1, 'votedown'))

    user2.vote post2, 'voteup', post2.user
    assert_equal(true,  user2.vote?(post2, 'voteup'))
    assert_equal(false, user2.vote?(post2, 'votedown'))

    # unvote
    user1.unvote post1, nil
    assert_equal(false, user1.vote?(post1, 'voteup'))
    assert_equal(false, user1.vote?(post1, 'votedown'))

    user2.unvote post2, ['voteup', 'votedown']
    assert_equal(false, user2.vote?(post2, 'voteup'))
    assert_equal(false, user2.vote?(post2, 'votedown'))
  end

  test "vote_by?/vote_by/unvote_by methods work" do
    user1, user2, user3 = User.all[0], User.all[1], User.all[2];
    post1, post2, post3 = Post.all[0], Post.all[1], Post.all[2];

    # vote_by?
    assert_equal(false, post1.vote_by?(post1, 'voteup'))
    assert_equal(false, post1.vote_by?(post1, 'votedown'))

    # vote_by
    post1.vote_by post1, 'voteup', post1.user
    post1.vote_by post1, 'votedown', post1.user
    assert_equal(true,  post1.vote_by?(post1, 'voteup'))
    assert_equal(true,  post1.vote_by?(post1, 'votedown'))

    post2.vote_by post2, 'voteup', post2.user
    assert_equal(true,  post2.vote_by?(post2, 'voteup'))
    assert_equal(false, post2.vote_by?(post2, 'votedown'))

    # unvote
    post1.unvote_by post1, nil
    assert_equal(false, post1.vote_by?(post1, 'voteup'))
    assert_equal(false, post1.vote_by?(post1, 'votedown'))

    post2.unvote_by post2, ['voteup', 'votedown']
    assert_equal(false, post2.vote_by?(post2, 'voteup'))
    assert_equal(false, post2.vote_by?(post2, 'votedown'))
  end

  test "method 'acts_as_voter' works" do
    user1, user2, user3 = User.all[0], User.all[1], User.all[2];
    post1, post2, post3 = Post.all[0], Post.all[1], Post.all[2];

    # generated macros
    assert_equal 0, user1.votes.count
    assert_equal 0, user2.votes.count
    assert_equal 0, user3.votes.count
    assert_equal 0, user1.owned_votes.count
    assert_equal 0, user2.owned_votes.count
    assert_equal 0, user3.owned_votes.count
    assert_equal 0, ActsAsVotable::Vote.count

    # vote
    user1.vote post3, 'votedown', post3.user
    user1.vote post1, 'voteup', post1.user
    user2.vote post1, 'voteup', post1.user

    # generated macros
    assert_equal 2, user1.votes.count
    assert_equal 1, user2.votes.count
    assert_equal 0, user3.votes.count
    assert_equal 2, user1.owned_votes.count
    assert_equal 0, user2.owned_votes.count
    assert_equal 1, user3.owned_votes.count
    assert_equal 3, ActsAsVotable::Vote.count

    # unvote
    user2.unvote(post1, 'voteup')
    assert_equal 2, user1.votes.count
    assert_equal 0, user2.votes.count # changed
    assert_equal 0, user3.votes.count
    assert_equal 1, user1.owned_votes.count # changed
    assert_equal 0, user2.owned_votes.count
    assert_equal 1, user3.owned_votes.count
    assert_equal 2, ActsAsVotable::Vote.count # changed

    user1.unvote(post3, ['voteup', 'votedown'])
    assert_equal 1, user1.votes.count
    assert_equal 0, user2.votes.count
    assert_equal 0, user3.votes.count
    assert_equal 1, user1.owned_votes.count
    assert_equal 0, user2.owned_votes.count
    assert_equal 0, user3.owned_votes.count
    assert_equal 1, ActsAsVotable::Vote.count
  end

  test "method 'acts_as_votable' works" do
    user1, user2, user3 = User.all[0], User.all[1], User.all[2];
    post1, post2, post3 = Post.all[0], Post.all[1], Post.all[2];

    # generated macros
    assert_equal 0, post1.votes.count
    assert_equal 0, post2.votes.count
    assert_equal 0, post3.votes.count
    assert_equal 0, ActsAsVotable::Vote.count

    # vote_by
    post3.vote_by user1, 'votedown', post3.user
    post1.vote_by user1, 'voteup', post1.user
    post1.vote_by user2, 'voteup', post1.user

    # generated macros
    assert_equal 2, post1.votes.count
    assert_equal 0, post2.votes.count
    assert_equal 1, post3.votes.count
    assert_equal 3, ActsAsVotable::Vote.count

    # unvote_by
    post1.unvote_by(user2, 'voteup')
    assert_equal 1, post1.votes.count
    assert_equal 0, post2.votes.count # changed
    assert_equal 1, post3.votes.count
    assert_equal 2, ActsAsVotable::Vote.count # changed

    post3.unvote_by(user1, ['voteup', 'votedown'])
    assert_equal 1, post1.votes.count
    assert_equal 0, post2.votes.count
    assert_equal 0, post3.votes.count
    assert_equal 1, ActsAsVotable::Vote.count
  end

  test "'acts_as_voter_on' generated methods work" do
    user1, user2, user3 = User.all[0], User.all[1], User.all[2];
    post1, post2, post3 = Post.all[0], Post.all[1], Post.all[2];

    # generated macros
    assert_equal 0, user1.voteup_posts_votes.count
    assert_equal 0, user1.voteup_posts.count
    assert_equal 0, user1.voteup_votes.count

    # voteup
    user1.voteup post1, post1.user
    user2.voteup post1, post2.user

    # voteup?
    assert_equal true, user1.voteup?(post1)
    assert_equal true, user2.voteup?(post1)
    assert_equal false, user3.voteup?(post1)

    # generated macros
    assert_equal 1, user1.voteup_posts_votes.count
    assert_equal 1, user1.voteup_posts.count
    assert_equal 1, user1.voteup_votes.count

    # voteup_count
    assert_equal 1, user1.voteup_count
    assert_equal 1, user2.voteup_count
    assert_equal 0, user3.voteup_count

    # unvoteup
    user2.unvoteup post1
    assert_equal true, user1.voteup?(post1)
    assert_equal false, user2.voteup?(post1)
    assert_equal false, user3.voteup?(post1)
  end

  test "'acts_as_votable_by' generated methods work" do
    user1, user2, user3 = User.all[0], User.all[1], User.all[2];
    post1, post2, post3 = Post.all[0], Post.all[1], Post.all[2];

    # generated macros
    assert_equal 0, post1.voteup_users_votes.count
    assert_equal 0, post1.voteup_users.count
    assert_equal 0, post1.voteup_votes.count

    # voteup_by
    post1.voteup_by user1, post1.user
    post2.voteup_by user1, post2.user

    # voteup_by?
    assert_equal true, post1.voteup_by?(user1)
    assert_equal true, post2.voteup_by?(user1)
    assert_equal false, post3.voteup_by?(user1)

    # generated macros
    assert_equal 1, post1.voteup_users_votes.count
    assert_equal 1, post1.voteup_votes.count
    assert_equal 1, post1.voteup_users.count

    # voteup_by_count
    assert_equal 1, post1.voteup_by_count
    assert_equal 1, post2.voteup_by_count
    assert_equal 0, post3.voteup_by_count

    # unvoteup_by
    post2.unvoteup_by user1
    assert_equal true, post1.voteup_by?(user1)
    assert_equal false, post2.voteup_by?(user1)
    assert_equal false, post3.voteup_by?(user1)
  end

  test "weight in vote model works" do
    user1, user2, user3 = User.all[0], User.all[1], User.all[2];
    post1, post2, post3 = Post.all[0], Post.all[1], Post.all[2];

    user1.vote(post2, 'voteup', post2.user, 5)
    user2.vote(post1, 'voteup', post1.user, 5)
    user3.vote(post1, 'voteup', post1.user, 5)
    assert_equal 15, ActsAsVotable::Vote.all.sum('weight')
    assert_equal  5, user1.votes.sum('weight')
    assert_equal 10, user1.owned_votes.sum('weight')

    user1.voteup(post3, post3.user)
    assert_equal 1, user3.owned_votes.sum('weight')
    user2.voteup(post3, post3.user, 10)
    assert_equal 11, user3.owned_votes.sum('weight')
    user2.votedown(post3, post3.user, -1)
    assert_equal 10, user3.owned_votes.sum('weight')
  end

  test "'acts_as_voter_on' allow first parameter is only action" do
    user1, user2, user3 = User.all[0], User.all[1], User.all[2];
    post1, post2, post3 = Post.all[0], Post.all[1], Post.all[2];

    # generated macros
    assert_equal 0, user1.accept_votes.count

    # accept
    user1.accept post1, post1.user
    user2.accept post1, post2.user

    # accept?
    assert_equal true, user1.accept?(post1)
    assert_equal true, user2.accept?(post1)
    assert_equal false, user3.accept?(post1)

    # generated macros
    assert_equal 1, user1.accept_votes.count

    # accept_count
    assert_equal 1, user1.accept_count
    assert_equal 1, user2.accept_count
    assert_equal 0, user3.accept_count

    # unaccept
    user2.unaccept post1
    assert_equal true, user1.accept?(post1)
    assert_equal false, user2.accept?(post1)
    assert_equal false, user3.accept?(post1)
  end

  test "'acts_as_votable_by' allow first parameter is only action" do
    user1, user2, user3 = User.all[0], User.all[1], User.all[2];
    post1, post2, post3 = Post.all[0], Post.all[1], Post.all[2];

    # generated macros
    assert_equal 0, post1.accept_votes.count

    # accept_by
    post1.accept_by user1, post1.user
    post2.accept_by user1, post2.user

    # accept_by?
    assert_equal true, post1.accept_by?(user1)
    assert_equal true, post2.accept_by?(user1)
    assert_equal false, post3.accept_by?(user1)

    # generated macros
    assert_equal 1, post1.accept_votes.count

    # accept_by_count
    assert_equal 1, post1.accept_by_count
    assert_equal 1, post2.accept_by_count
    assert_equal 0, post3.accept_by_count

    # unaccept_by
    post2.unaccept_by user1
    assert_equal true, post1.accept_by?(user1)
    assert_equal false, post2.accept_by?(user1)
    assert_equal false, post3.accept_by?(user1)
  end
end
