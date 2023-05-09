class OrderMailer < ApplicationMailer

  SENDER_MAIL = 'Paul <depot@example.com>'.freeze

  default from: SENDER_MAIL

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.received.subject
  #
  def received(order_id)
    @order = Order.find(order_id)
    @line_items = @order.line_items.includes(:product)
    locale = @order.user.language_preference

    @line_items.each_with_index do |line_item, idx|
      if line_item.product.images.count > 1
        other_images = line_item.product.images[1..]
        
        other_images.each_with_index do |image, index|
          attachments.inline["item_#{idx + 1}_image_#{index + 2}"] = image.download
        end
      end
    end
    
    I18n.with_locale(locale) do
      mail to: @order.email, subject: t('.order_confirmation') do |format|
        format.html
        format.text
      end
    end
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.shipped.subject
  #
  def shipped(order)
    @order = order
    mail to: order.email, subject: 'Pragmatic Store Order Shipped'
  end
end
