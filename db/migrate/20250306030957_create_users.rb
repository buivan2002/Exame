class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :role
      t.datetime :last_login_at
      t.string :avatar_url
      t.string :oauth_provider
      t.string :oauth_id

      t.timestamps
    end
  end
end
