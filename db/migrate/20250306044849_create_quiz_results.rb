class CreateQuizResults < ActiveRecord::Migration[7.0]
  def change
    create_table :quiz_results do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.integer :score, null: false, default: 0
      t.integer :correct_answers, null: false, default: 0
      t.integer :incorrect_answers, null: false, default: 0
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :status, null: false, default: 'completed'

      t.timestamps
    end
  end
end
