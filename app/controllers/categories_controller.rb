class CategoriesController < ApplicationController
  def index
    @categories = Category.base_categories.includes(:sub_categories)
  end

  def show
    @category = Category.find(id_params)
    @products = @category.fetch_products
  end

  private

    def id_params
      params.require(:id)
    end
end
