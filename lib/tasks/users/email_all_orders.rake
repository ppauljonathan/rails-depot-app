namespace :users do
  desc 'send a consolidated email for each user displaying all of their orders'
  task email_all_orders: :development do
    User.all.each do |user|
      UserMailer.consolidated_orders(user_id).deliver_later unless user.orders.empty?
    end
  end
end
