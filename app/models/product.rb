class Product < ApplicationRecord
  has_many :line_items
  validates :title, presence: true
  validates :description, length: { minimum: 10 }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }
  before_destroy :ensure_not_referenced_by_any_line_items

  private

  def ensure_not_referenced_by_any_line_items
    unless line_items.empty?
      errors.add(:base, 'Line Items Present')
      throw :abort
    end
  end
end
