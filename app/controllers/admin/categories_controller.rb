class Admin::CategoriesController < ApplicationController
  def index
    @categories = Category.includes(:parent)
  end
end
