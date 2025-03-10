class AddUniqueIndexToLeaderBoard < ActiveRecord::Migration[6.0]
  def change
    # Xóa khóa ngoại trước nếu tồn tại
    execute "ALTER TABLE leader_boards DROP FOREIGN KEY fk_rails_337ce40078;" rescue nil

    # Xóa index cũ nếu tồn tại
    if index_exists?(:leader_boards, :user_id)
      remove_index :leader_boards, :user_id
    end

    # Thêm index mới với unique constraint
    add_index :leader_boards, :user_id, unique: true

    # Thêm lại khóa ngoại với ON DELETE CASCADE để tránh lỗi sau này
    add_foreign_key :leader_boards, :users, on_delete: :cascade
  end
end
