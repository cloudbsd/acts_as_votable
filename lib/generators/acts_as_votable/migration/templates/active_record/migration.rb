class ActsAsVotableMigration < ActiveRecord::Migration
  def change
    create_table :votes, :force => true do |t|
      t.belongs_to :votable, polymorphic: true, :null => false, index: true
      t.belongs_to :voter, polymorphic: true, :null => false, index: true
      t.belongs_to :owner, polymorphic: true, :null => false, index: true
      t.string  :action, :null => false
      t.string  :response
      t.integer :weight, :null => false, :default => 0

      t.timestamps
    end
  end
end
