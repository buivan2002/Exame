class CreateQuizzes < ActiveRecord::Migration[7.0]
  def change
    create_table :quizzes do |t|
      t.string :title
      t.references :quiz_setting, null: false, foreign_key: true
      t.string :description
      t.references :category, null: false, foreign_key: true
      t.string :difficulty
      t.integer :total_questions
      t.integer :time_limit
      t.boolean :status
      
      t.timestamps
    end
  end
end
