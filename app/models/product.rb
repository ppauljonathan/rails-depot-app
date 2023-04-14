class UrlValidator < ActiveModel::EachValidator

  DEFAULT_TITLE = 'abc'.freeze

  def validate_each(record, attribute, value)
    return unless value =~ PERMITTED_IMAGE_URL_TYPES_REGEX

    record.errors.add(
      attribute,
      (options[:message] || 'must be a URL for GIF, JPG or PNG image.')
    )
  end
end

class Product < ApplicationRecord
  before_validation :set_default_title, unless: :title
  before_validation :set_default_discount_price, if: :price, unless: :discount_price

  has_many :line_items
  validates :title, presence: true
  validates :words_in_description, length: { in: 5..10, message: 'should be between 5 and 10 words' }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, allow_blank: true
  validates :image_url, allow_blank: true, url: true

  validates :permalink, uniqueness: true, format: {
    without: SPECIAL_CHARACTERS_AND_SPACES_REGEX,
    message: 'must not contain special characters or spaces.'
  }

  validates :hyphenated_words_in_permalink, allow_blank: true, length: {
    minimum: 3,
    message: 'must be atleast 3 words long and separated with hyphens'
  }

  # without custom validator
  validates :discount_price, numericality: { less_than: :price, greater_than_or_equal_to: 0.01 }, allow_blank: true

  # with custom validator
  # validate :price_greater_than_discount_price

  before_destroy :ensure_not_referenced_by_any_line_items

  private

    def ensure_not_referenced_by_any_line_items
      unless line_items.empty?
        errors.add(:base, 'Line Items Present')
        throw :abort
      end
    end

    def hyphenated_words_in_permalink
      permalink&.split('-')
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
end
