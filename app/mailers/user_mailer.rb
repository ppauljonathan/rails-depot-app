class UserMailer < ApplicationMailer

  SENDER_MAIL = 'Paul <depot@example.com>'.freeze

  default from: SENDER_MAIL

  def registered(user_id)
    @user = User.find(user_id)
    return unless @user

    mail to: @user.email, subject: t('.welcome')
  end
end
