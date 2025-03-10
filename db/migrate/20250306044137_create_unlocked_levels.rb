class CreateUnlockedLevels < ActiveRecord::Migration[7.0]
  def change
    create_table :unlocked_levels do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :difficulty
      t.datetime :unlock_date, null: false
      t.string :status
      t.integer :comleted_quiz
      t.integer :required_quiz
      
      t.timestamps
    end
  end
end
