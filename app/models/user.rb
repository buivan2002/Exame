class User < ApplicationRecord
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
  has_one :quiz_settings, dependent: :destroy

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

  private

  def set_default_role
    self.role ||= "user" # Mặc định là "user"
  end
end 
