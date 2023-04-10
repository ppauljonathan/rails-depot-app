class UserMailer < ApplicationMailer
  default from: 'Paul <depot@example.com>'

  def registered(user)
    @user = user
    mail to: user.email, subject: 'Welcome'
  end
end
