class CreateLeaderBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :leader_boards do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :score
      t.integer :rank
      
      t.timestamps
    end
  end
end
