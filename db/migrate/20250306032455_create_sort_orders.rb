class CreateSortOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :sort_orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.integer :order, null: false

      t.timestamps
    end
  end
end
