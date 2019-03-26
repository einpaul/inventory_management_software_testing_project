class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all
    @suppliers = Supplier.all
    @products = Product.all
    @active = Order.active?
    @expired = Order.expired?
  end

  def old
    @inactive = Order.inactive?
  end

  def renew
    @current_user = current_user
    @order = Order.find_by_id(params[:id])
    Order.renew(params[:id])
    redirect_to :root
    flash[:notice] = "Renewed for 7 days from now. Enjoy!"

    begin
      OrderMailer.delay.renew_order(@order, @current_user).deliver
    rescue Exception => e
    end
  end

  def return
    purchased_qty = Order.find_by_id(params[:id]).quantity.to_i
    @purchased_product = Order.find_by_id(params[:id]).product
    @purchased_product.increment!(:remaining_quantity, purchased_qty)
    @current_user = current_user
    @order = Order.find_by_id(params[:id])
    Order.return(params[:id])
    redirect_to :root
    flash[:notice] = "Product marked as returned. Thank you!"

    begin
      OrderMailer.delay.return_order(@order, @current_user).deliver
    rescue Exception => e
    end
  end

  def new
    @order = Order.new
    @supplier = Supplier.all
  end

  def create
    if Product.find_by_id(params[:order][:product_id]).remaining_quantity >= params[:order][:quantity].to_i
      params[:order][:status] = true
      @order = Order.new(order_params)
      if @order.save
        @current_user = current_user
        @purchased_product = Product.find_by_id(params[:order][:product_id])
        @purchased_product.decrement!(:remaining_quantity, params[:order][:quantity].to_i)
        redirect_to :root, notice: 'Order was successfully created.'
        begin
          OrderMailer.delay.create_order(@order, @current_user).deliver
        rescue Exception => e
        end
      else
        render :new
      end
    else
      flash[:alert] = 'The quantity you entered is not currently available'
      redirect_to :back
    end
  end

  def destroy
    purchased_qty = @order.quantity.to_i
    @purchased_product = @order.product
    @purchased_product.increment!(:remaining_quantity, purchased_qty)
    @current_user = current_user
    @order.destroy

    redirect_to orders_url, notice: 'Order was successfully destroyed.'
    begin
      OrderMailer.delay.cancel_order(@order, @current_user).deliver
    rescue Exception => e
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:quantity, :expire_at, :status, :item_id, :member_id)
    end
end
