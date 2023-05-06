class CategoriesController < ApplicationController
  def index
    @categories = Category.base_categories.includes(:sub_categories)
  end
end
