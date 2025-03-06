class CreateCharts < ActiveRecord::Migration[7.0]
  def change
    create_table :charts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.datetime :date, null: false
      t.integer :quiz_taken, default: 0
      t.integer :correct_answers, default: 0
      t.integer :wrong_answers, default: 0
      t.integer :total_score, default: 0

      t.timestamps
    end
  end
end
