class CreateAuthLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :auth_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :login_at, null: false
      t.string :ip_address, null: false
      t.string :user_agent, null: false
      t.string :status, null: false
      t.datetime :logout_at, null: true

      t.timestamps
    end
  end
end
