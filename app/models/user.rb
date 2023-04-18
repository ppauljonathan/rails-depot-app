class User < ApplicationRecord

  ADMIN_USER_EMAIL = 'admin@depot.com'.freeze

  before_destroy :ensure_admin_is_not_updated_or_deleted, if: :is_admin?
  before_update :ensure_admin_is_not_updated_or_deleted, if: :is_admin?

  after_create_commit :send_confirmation_email

  validates :name, presence: true, uniqueness: true
  has_secure_password

  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_destroy :ensure_an_admin_remains

  private

    def ensure_an_admin_remains
      if User.count.zero?
        raise UserDeleteError, "Can't Delete Last User"
      end
    end

    def send_confirmation_email
      UserMailer.registered(id).deliver_later
    end

    def is_admin?
      email == ADMIN_USER_EMAIL
    end

    def ensure_admin_is_not_updated_or_deleted
      errors.add :base, 'Cannot Update or Delete Admin User'
      throw :abort
    end
end
