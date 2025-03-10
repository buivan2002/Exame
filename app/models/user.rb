class User < ApplicationRecord
  has_many :auth_logs
  has_many :charts
  has_many :favorites
  has_many :follows, foreign_key: "follower_id"
  has_many :followers, class_name: "Follow", foreign_key: "followed_id"
  has_one :leader_boards
  has_many :notifications
  has_many :point_histories
  has_one :points
  has_many :quiz_results
  has_one :quiz_settings
  has_many :sort_orders
  has_many :statistics
  has_many :unlocked_levels
  has_many :user_answers

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
