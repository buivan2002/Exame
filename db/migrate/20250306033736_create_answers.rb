class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.references :question, null: false, foreign_key: true
      t.text :body
      t.boolean :is_correct
      t.string :image_url

      t.timestamps
    end
  end
end
