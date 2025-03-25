class CreatePointRewards < ActiveRecord::Migration[7.0]
  def change
    create_table :point_rewards do |t|
      t.string :name, null: false
      t.text :description
      t.integer :required_points, null: false, default: 0
      t.integer :quantity, null: false, default: 0
      t.integer :redeemed, null: false, default: 0
      t.integer :status, null: false, default: 0  # 0: có sẵn, 1: ẩn, 2: hết hạn

      t.timestamps
    end
  end
end
