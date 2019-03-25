class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
    @category = Category.all
  end

  def edit
    @category = Category.all
  end

  def create
    params[:product][:remaining_quantity] = params[:product][:quantity]
    @product = Product.new(product_params)
    if @product.save
      redirect_to :root, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to :root, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  private
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :category_id, :quantity, :description, :remaining_quantity, :code)
  end
end
