class CreateLevelConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :level_configs do |t|
      t.integer :level, null: false
      t.string :name, null: false
      t.integer :required_points, null: false, default: 0
      t.integer :quiz_reward, null: false, default: 0
      t.integer :login_reward, null: false, default: 0
      t.boolean :status, null: false, default: true
      
      t.timestamps
    end
  end
end
