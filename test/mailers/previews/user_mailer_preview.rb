# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def consolidated_orders
    UserMailer.consolidated_orders(3)
  end

  def registered
    UserMailer.registered(3)
  end
end
