class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  def index
    @suppliers = Supplier.all
  end

  def new
    @supplier = Supplier.new
  end

  def edit
  end

  def create
    @supplier = Supplier.new(supplier_params)
    if @supplier.save
      redirect_to :root, notice: 'Supplier was successfully created.'
    else
      render :new
    end
  end

  def update
    if @supplier.update(supplier_params)
      redirect_to :root, notice: 'Supplier was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @supplier.orders.where(status: true).count == 0
      @supplier.destroy
      redirect_to :root, notice: 'Supplier was successfully destroyed.'
    else
      flash[:alert] = 'Suppliers with active orders can not be deleted. Mark his/hers open orders as returned and try again.'
      redirect_to root_url
    end
  end

  private
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    def supplier_params
      params.require(:supplier).permit(:name, :email, :phone)
    end
end
