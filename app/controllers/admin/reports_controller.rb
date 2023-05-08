class Admin::ReportsController < ApplicationController
  def index
    from_date = params[:from_date] || Time.current() - 5.day
    to_date = params[:to_date] || Time.current
    @orders = Order.by_date(from_date, to_date)
                   .includes(:line_items)
                   .includes(line_items: :product)
  end
end
