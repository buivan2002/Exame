class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :role, :string, default: "user"
    add_column :users, :last_login_at, :datetime
    add_column :users, :avatar_url, :string
    add_column :users, :oauth_provider, :string
    add_column :users, :oauth_id, :string
  end
end
