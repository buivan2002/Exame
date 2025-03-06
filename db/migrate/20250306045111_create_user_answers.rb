class CreateUserAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :user_answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true
      t.boolean :is_correct, default: false
      t.references :category, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
