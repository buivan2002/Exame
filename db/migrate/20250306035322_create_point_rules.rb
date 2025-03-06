class CreatePointRules < ActiveRecord::Migration[7.0]
  def change
    create_table :point_rules do |t|
      t.references :category, null: false, foreign_key: true
      t.string :difficulty, null: false
      t.integer :point_awarded, null: false

      t.timestamps
    end
  end
end
