class Admin::CategoriesController < ApplicationController
  def index
    @categories = Category.includes(:super_category)
  end
end
