class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product
  belongs_to :cart, optional: true, counter_cache: true

  validates :product_id, uniqueness: { scope: :cart_id, message: 'should be given only once in cart' }, if: :cart_id

  def total_price
    product.price * quantity
  end
end
