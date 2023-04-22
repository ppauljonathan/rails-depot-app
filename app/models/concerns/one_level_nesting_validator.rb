class OneLevelNestingValidator < ActiveModel::Validator
  def validate(record)
    return unless record.super_category&.super_category_id

    record.errors.add :base, 'cannot add subcategory for a subcategory'
  end
end