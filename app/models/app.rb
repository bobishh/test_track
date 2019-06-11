class App < ActiveRecord::Base
  has_many :splits, foreign_key: :owner_app_id
  has_many :identifier_types, foreign_key: :owner_app_id

  validates :name, :auth_secret, presence: true
  validates :name, uniqueness: true

  private

  def auth_secret_must_be_sufficiently_strong
    return if auth_secret && auth_secret.size >= 43
    errors.add(:auth_secret, "must be at least 32-bytes, Base64 encoded")
  end
end
