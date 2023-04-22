class Product < ApplicationRecord

  SPECIAL_CHARACTERS_AND_SPACES_REGEX = /[^[:alnum:]|-]/i.freeze
  
  has_many :line_items, dependent: :restrict_with_error
  has_many :carts, through: :line_items

  belongs_to :category, counter_cache: true

  after_create_commit :increment_super_category_counter
  after_update_commit :update_super_category_counter
  after_destroy_commit :decrement_super_category_counter

  validates :title, presence: true
  validates :words_in_description, length: { in: 5..10, message: 'should be between 5 and 10 words' }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, allow_blank: true
  validates :image_url, allow_blank: true, url: true

  validates :permalink, uniqueness: true, format: {
    without: SPECIAL_CHARACTERS_AND_SPACES_REGEX,
    message: 'must not contain special characters or spaces.'
  }

  validates :hyphenated_words_in_permalink, length: {
    minimum: 3,
    message: 'must be atleast 3 words long and separated with hyphens'
  }, if: :permalink

  # without custom validator
  validates :discount_price,
            numericality: { less_than: :price, greater_than_or_equal_to: 0.01 },
            allow_blank: true,
            if: :price

  # with custom validator
  validate :price_greater_than_discount_price, if: %i[discount_price price]

  scope :enabled_products, -> { where enabled: true }

  # Build queries for following
  #   - Get All products which are present in atleast one line_item
  scope :products_in_line_item, -> { joins(:line_items).distinct }
  #   - Get array of product titles which are present in atleast one line item
  scope :product_titles_in_line_item, -> { products_in_line_item.pluck(:title) }
  

  private

    def hyphenated_words_in_permalink
      permalink.split('-')
    end

    def words_in_description
      description&.split
    end

    def price_greater_than_discount_price
      errors.add(:discount_price, "must be less than #{price}") if price <= discount_price
    end

    def set_default_title
      self.title = DEFAULT_TITLE
    end

    def set_default_discount_price
      self.discount_price = price
    end

    def increment_super_category_counter
      Category.increment_counter(:products_count, category.super_category_id)
    end

    def decrement_super_category_counter
      Category.decrement_counter(:products_count, category.super_category_id)
    end

    def update_super_category_counter
      return unless category_id_previously_changed?

      prev_super_category_id = Category.find(category_id_previously_was).super_category_id

      Category.decrement_counter(:products_count, prev_super_category_id)
      increment_super_category_counter
    end
end
