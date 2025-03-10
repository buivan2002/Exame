class CreateStatistics < ActiveRecord::Migration[7.0]
  def change
    create_table :statistics do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.integer :total_correct_answers, default: 0
      t.integer :total_incorrect_answers, default: 0
      t.datetime :date
      
      t.timestamps
    end
  end
end
