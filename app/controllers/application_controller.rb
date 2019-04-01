class ApplicationController < ActionController::Base

  include Pundit

  protect_from_forgery with: :exception
  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

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

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end

end
