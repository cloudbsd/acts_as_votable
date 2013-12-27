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

      def vote_by?(voter, action)
        self.votes.find_by(voter: voter, action: action).present?
      end

      def vote_by(voter, action, owner = nil, weight = 1)
        self.votes.create(voter: voter, action: action, owner: owner, weight: weight)
      end

      def unvote_by(voter, actions)
        if actions.nil?
          self.votes.where(voter: voter).destroy_all
        # self.votes.where(voter: voter, action: action).destroy_all
        else
          conditions = []
          Array(actions).each do |act|
            conditions << "action = '#{act}'"
          end
          self.votes.where(voter: voter).where(conditions.join(" or ")).destroy_all
        end
      end

    end # module Methods
  end # module Votable
end # module ActsAsVotable
