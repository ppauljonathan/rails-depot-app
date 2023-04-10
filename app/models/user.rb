class User < ApplicationRecord
  class AdminCallbacks
    def self.raise_error(user, action)
      return unless user.is_admin?

      user.errors.add(:base, "Can't #{action} Admin user")
      throw :abort
    end

    def self.before_destroy(user)
      raise_error(user, :destroy)
    end

    def self.before_update(user)
      raise_error(user, :update)
    end
  end

  before_destroy AdminCallbacks
  before_update AdminCallbacks

  after_create_commit :send_confirmation_email

  validates :name, presence: true, uniqueness: true
  has_secure_password

  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_destroy :ensure_an_admin_remains

  class Error < StandardError
  end

  def is_admin?
    email == 'admin@depot.com'
  end

  private

    def ensure_an_admin_remains
      if User.count.zero?
        raise Error.new "Can't Delete Last User"
      end
    end

    def send_confirmation_email
      UserMailer.registered(self).deliver_later
    end
end
