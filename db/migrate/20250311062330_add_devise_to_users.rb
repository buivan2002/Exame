class AddDeviseToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      ## Chỉ thêm cột nếu nó chưa tồn tại
      t.string :encrypted_password, null: false, default: "" unless column_exists?(:users, :encrypted_password)

      t.string   :reset_password_token unless column_exists?(:users, :reset_password_token)
      t.datetime :reset_password_sent_at unless column_exists?(:users, :reset_password_sent_at)

      t.datetime :remember_created_at unless column_exists?(:users, :remember_created_at)
    end

    add_index :users, :email, unique: true unless index_exists?(:users, :email)
    add_index :users, :reset_password_token, unique: true unless index_exists?(:users, :reset_password_token)
  end
end
