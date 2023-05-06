class OneLevelNestingValidator < ActiveModel::Validator
  def validate(record)
    return unless record.parent&.parent_id

    record.errors.add :base, 'cannot add subcategory for a subcategory'
  end
end