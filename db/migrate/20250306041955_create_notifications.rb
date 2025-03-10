class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.text :message
      t.string :type
      t.boolean :status, default: false
      
      t.timestamps
    end
  end
end
