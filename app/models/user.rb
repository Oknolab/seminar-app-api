class User < ApplicationRecord
  validate :validate_email
  with_options presence: true do
    validates :name
    validates :password
    validates :email, uniqueness: true
  end

  private

  # email属性が有効なメールアドレスフォーマットであることを検証するメソッド
  def validate_email
    unless email =~ URI::MailTo::EMAIL_REGEXP
      errors.add(:email, "is not a valid email format")
    end
  end
end
