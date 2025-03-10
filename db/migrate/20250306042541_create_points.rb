class CreatePoints < ActiveRecord::Migration[7.0]
  def change
    create_table :points do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total_point, default: 0
      t.integer :level, default: 1
      
      t.timestamps
    end
  end
end
