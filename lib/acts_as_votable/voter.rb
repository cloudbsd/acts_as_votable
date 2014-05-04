module ActsAsVotable
  module Voter
    module Methods
      extend ActiveSupport::Concern

      self.included do
      end

      module ClassMethods
        def is_voter?
          true
        end
      end # module ClassMethods

      def vote?(votable, actions)
        self.votes.exists?(votable: votable, action: actions)
      end

      def vote(votable, action, owner, weight = 1)
        self.votes.create(votable: votable, action: action, owner: owner, weight: weight)
      end

      def unvote(votable, actions)
        if actions.nil?
          self.votes.where(votable: votable).destroy_all
        # self.votes.where(votable: votable, action: action).destroy_all
        else
          self.votes.where(votable: votable, action: actions).destroy_all
        # conditions = []
        # Array(actions).each do |act|
        #   conditions << "action = '#{act}'"
        # end
        # self.votes.where(votable: votable).where(conditions.join(" or ")).destroy_all
        end
      end

    end # module Methods
  end # module Voter
end # module ActsAsVotable
