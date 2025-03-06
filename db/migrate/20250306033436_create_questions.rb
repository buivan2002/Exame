class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.references :category, null:false, foreign_key: true
      t.string :content, null:false
      t.string :question_type, null:false
      t.string :difficulty, null:false
      t.string :status, null:false
      t.string :explanation, null: true
      t.string :image_url, null: true

      t.timestamps
    end
  end
end
