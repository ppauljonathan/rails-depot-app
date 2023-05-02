class Category < ApplicationRecord
  belongs_to :super_category, class_name: 'Category', optional: true
  has_many :sub_categories, class_name: 'Category', foreign_key: :super_category_id, dependent: :destroy
  has_many :products, dependent: :restrict_with_error
  has_many :subcategory_products, through: :sub_categories, source: :products, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { scope: :super_category_id }
  validates_with OneLevelNestingValidator

  scope :base_categories, -> { where super_category: nil }

  def fetch_products
    return products if super_category_id

    product_list = []
    product_list.append(*products)

    sub_categories.each do |sub_category|
      product_list.append(*sub_category.fetch_products)
    end

    product_list
  end
end
