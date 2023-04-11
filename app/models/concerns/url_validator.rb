class UrlValidator < ActiveModel::EachValidator

  PERMITTED_IMAGE_URL_TYPES_REGEX = /\.(gif|jpg|png)\z/i.freeze

  def validate_each(record, attribute, value)
    return if value =~ PERMITTED_IMAGE_URL_TYPES_REGEX

    record.errors.add(
      attribute,
      (options[:message] || 'must be a URL for GIF, JPG or PNG image.')
    )
  end
end