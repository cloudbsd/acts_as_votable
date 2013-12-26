require 'active_support'
require 'active_model'
require 'active_record'

require "acts_as_votable/version"
require "acts_as_votable/vote"
require "acts_as_votable/voter"
require "acts_as_votable/votable"

module ActsAsVotable
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def acts_as_votable(options={})
      do_acts_as_votable(options)
    end

    # action_voters = :favorite_users
    #   names = favorite_users
    #   names[0] = favorite_users
    #   action_name = names[1] = 'favorite'
    #   names[2] = users
    #   action_votes = favorite_votes
    #   action_voters_votes = favorite_users_votes
    def acts_as_votable_by(action_voters, options={})
      do_acts_as_votable(options)

      if action_voters.present?
        names = /(.+?)_(.+)/.match(action_voters.to_s)
        action_name = names[1]
        object_type = names[2].singularize.camelize
        action_votes = (action_name + '_votes').to_sym
        action_voter_votes = (names[0] + '_votes').to_sym

        has_many action_voter_votes, -> { where(action: action_name, voter_type: object_type) }, as: :votable, dependent: :destroy, class_name: 'ActsAsVotable::Vote'
        has_many action_votes, -> { where(action: action_name) }, as: :votable, dependent: :destroy, class_name: 'ActsAsVotable::Vote'
        has_many action_voters, through: action_voter_votes, source: :voter, source_type: object_type

        define_method("#{action_name}_by?") do |voter|
          self.vote_by?(voter, action_name)
        end

        define_method("#{action_name}_by") do |voter, owner|
          self.vote_by(voter, action_name, owner)
        end

        define_method("un#{action_name}_by") do |voter|
          self.unvote_by(voter, action_name)
        end
      end
    end # acts_as_votable_by

    def acts_as_voter(options={})
      do_acts_as_voter(options)
    end

    def acts_as_voter_on(action_votables, options={})
      do_acts_as_voter(options)

      if action_votables.present?
        names = /(.+?)_(.+)/.match(action_votables.to_s)
        action_name = names[1]
        object_type = names[2].singularize.camelize
        action_votes = (action_name + '_votes').to_sym
        action_votables_votes = (names[0] + '_votes').to_sym

        has_many action_votables_votes, -> { where(action: action_name, votable_type: object_type) }, as: :voter, dependent: :destroy, class_name: 'ActsAsVotable::Vote'
        has_many action_votes, -> { where(action: action_name) }, as: :voter, dependent: :destroy, class_name: 'ActsAsVotable::Vote'
        has_many action_votables, through: action_votables_votes, source: :votable, source_type: object_type

        define_method("#{action_name}?") do |votable|
          self.vote?(votable, action_name)
        end

        define_method("#{action_name}") do |votable, owner|
          self.vote(votable, action_name, owner)
        end

        define_method("un#{action_name}") do |votable|
          self.unvote(votable, action_name)
        end
      end
    end # acts_as_voter_on

    def do_acts_as_votable(options={})
      unless self.is_votable?
        has_many :votes, {as: :votable, dependent: :destroy, class_name: 'ActsAsVotable::Vote'}.merge(options)
        include ActsAsVotable::Votable::Methods
      end
    end

    def do_acts_as_voter(options={})
      unless self.is_voter?
        has_many :votes, {as: :voter, dependent: :destroy, class_name: 'ActsAsVotable::Vote'}.merge(options)
        has_many :owned_votes, {as: :owner, dependent: :destroy, class_name: 'ActsAsVotable::Vote'}.merge(options)
        include ActsAsVotable::Voter::Methods
      end
    end

    def is_votable?
      false
    end

    def is_voter?
      false
    end
  end # ClassMethods
end # ActsAsVotable


ActiveRecord::Base.send :include, ActsAsVotable
