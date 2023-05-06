class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    respond_to do |format|
      format.html { @products = Product.all.order(:title) }
      format.json { render json: Product.joins(:category).select(:title, :name, :id) }
    end
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: t('.message') }
        format.json { render :show, status: :created, location: @product }

        @products = Product.all.order(:title)
        # minor error in passing error, not part of associations PR pls ignore
        ActionCable.server.broadcast('products', { html: render_to_string('store/index', layout: false) })
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: t('.message') }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    
    if @product.destroy
      respond_to do |format|
        format.html { redirect_to products_url, notice: t('.message') }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @product, notice: t('.error')}
      end
    end
  end

  def who_bought
    @product = Product.find(params[:id])
    @latest_order = @product.orders.order(:updated_at).last
    if stale?(@latest_order)
      respond do |format|
        format.atom
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(
        :title,
        :description,
        :image_url,
        :price,
        :enabled,
        :discount_price,
        :permalink,
        :category_id,
        images: []
      )
    end
end
