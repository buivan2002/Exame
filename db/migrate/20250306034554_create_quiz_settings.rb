class CreateQuizSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :quiz_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :difficulty # easy, medium, hard
      t.float :percen_complete # percentage of questions answered correctly
      t.integer :total_quiz
      t.integer :total_correct_answers
      t.string :question_max
      t.integer :question_increase

      t.timestamps
    end
  end
end
