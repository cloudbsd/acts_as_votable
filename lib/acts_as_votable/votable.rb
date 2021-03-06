module ActsAsVotable
  module Votable
    module Methods
      extend ActiveSupport::Concern

      self.included do
      end

      module ClassMethods
        def is_votable?
          true
        end
      end # module ClassMethods

      def vote_by?(voter, actions)
        self.votes.exists?(voter: voter, action: actions)
      end

      def vote_by(voter, action, owner = nil, weight = 1)
        self.votes.create(voter: voter, action: action, owner: owner, weight: weight)
      end

      def unvote_by(voter, actions)
        if actions.nil?
          self.votes.where(voter: voter).destroy_all
        else
          self.votes.where(voter: voter, action: actions).destroy_all
        end
      end

    end # module Methods
  end # module Votable
end # module ActsAsVotable
