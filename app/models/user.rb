class User < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  has_many :auth_logs, dependent: :destroy
  has_many :charts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :point_histories, dependent: :destroy
  has_many :quiz_results, dependent: :destroy
  has_many :statistics, dependent: :destroy
  has_many :unlocked_levels, dependent: :destroy
  has_many :user_answers, dependent: :destroy
  has_many :sort_orders, dependent: :destroy

  # Quan hệ 1-1
  has_one :point, dependent: :destroy
  has_one :leader_board, dependent: :destroy
  has_one :quiz_settings

  # Quan hệ n-n (self-referential)
  has_many :follows, foreign_key: "follower_id", dependent: :destroy
  has_many :followers, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

         
  def self.from_omniauth(access_token)
    where(provider: access_token.provider, uid: access_token.uid).first_or_create do |user|
      user.email = access_token.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
   enum role: { user: "user", admin: "admin" }, _default: "user"

  after_initialize :set_default_role, if: :new_record?

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name, type: :text, analyzer: 'standard'
      indexes :email, type: :text, analyzer: 'standard'
      indexes :avatar_url, type: :keyword
      indexes :role, type: :keyword
      indexes :last_login_at, type: :date
      indexes :followers_count, type: :integer
    end
  end


  # Lấy danh sách ID những người mà user hiện tại đang follow
  

  # Chuyển đổi dữ liệu của User thành JSON để index vào Elasticsearch
  def as_indexed_json(options = {})
    # return {} unless role == "user"  # Chỉ index user, bỏ qua admin

    {
      id: id,
      name: name,
      email: email,
      avatar_url: avatar_url,
      role: role,
      last_login_at: last_login_at,
      followers_count: followers.count, # Tổng số người follow user này
    }
    
    
  end
 
  # Cập nhật lại index của Elasticsearch khi có thay đổi
  after_commit -> {
    puts "🔥🔥🔥 Elasticsearch indexing user #{self.id}"
    __elasticsearch__.index_document }, on: [:create, :update]
  private

  def set_default_role
    self.role ||= "user" # Mặc định là "user"
  end

  def online?
    return true
  end
end
