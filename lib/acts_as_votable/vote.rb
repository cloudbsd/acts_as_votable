module ActsAsVotable
  class Vote < ActiveRecord::Base
    belongs_to :votable, :polymorphic => true
    belongs_to :voter, :polymorphic => true
    belongs_to :owner, :polymorphic => true

    validates :votable_id, presence: true
    validates :votable_type, presence: true
    validates :voter_id, presence: true
    validates :voter_type, presence: true
  # validates :owner_id, presence: true
  # validates :owner_type, presence: true
  # validates :action, presence: true
    validates :weight, presence: true, numericality: true
  end
end
