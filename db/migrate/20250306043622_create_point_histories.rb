class CreatePointHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :point_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :point
      t.text :reason
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
