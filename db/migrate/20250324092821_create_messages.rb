class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :user_email
      t.text :text
      t.string :room_id

      t.timestamps
    end
  end
end
