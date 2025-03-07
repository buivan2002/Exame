class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(access_token)
    where(provider: access_token.provider, uid: access_token.uid).first_or_create do |user|
      user.email = access_token.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
  enum role: { user: 0, admin: 1 } # Định nghĩa vai trò
  after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role ||= :user # Mặc định là user
  end
end 