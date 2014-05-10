module ActsAsVotable
  class Vote < ActiveRecord::Base
    belongs_to :votable, :polymorphic => true
    belongs_to :voter, :polymorphic => true
    belongs_to :owner, :polymorphic => true

    validates :votable, presence: true
    validates :voter, presence: true
    validates :owner, presence: true
    validates :action, presence: true
    validates :weight, presence: true, numericality: true
  end
end
