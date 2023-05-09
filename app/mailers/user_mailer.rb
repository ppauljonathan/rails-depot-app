class UserMailer < ApplicationMailer

  SENDER_MAIL = 'Paul <depot@example.com>'.freeze

  default from: SENDER_MAIL

  def registered(user_id)
    @user = User.find(user_id)
    return unless @user

    I18n.with_locale(@user.language_preference) do
      mail to: @user.email, subject: t('.welcome')
    end
  end

  def consolidated_orders(user_id)
    @user = User.find(user_id)
    return unless @user

    @orders = @user.orders
    
    I18n.with_locale(@user.language_preference) do
      mail to: @user.email, subject: t('.consolidated_orders')
    end
  end
end
