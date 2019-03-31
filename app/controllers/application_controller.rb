class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def check_supplier_status
    return if params[:order][:supplier_id].blank?
    @supplier = Supplier.find(params[:order][:supplier_id])
    if @supplier.active?
      true
    else
      flash[:alert] = "The supplier you selected is currently #{@supplier.status}."
      false
      redirect_to products_path
    end
  end
end
