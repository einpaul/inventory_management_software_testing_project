class OrderMailer < ApplicationMailer
  def create_order(order, current_user)
    @order = order
    @user = current_user

    mail to: @order.supplier.email, subject: @order.supplier.name + " ordered " + @order.quantity + " x " + @order.product.name + " from " + @user.name
  end

  def renew_order(order, current_user)
    @order = order
    @user = current_user

    mail to: ENV['ACTION_MAILER_SEND_TO'], subject: "Product ordered by " + @order.supplier.name + " has been renewed for 7 days from " + @user.name
  end


  def return_order(order, current_user)
    @order = order
    @user = current_user

    mail to: @order.supplier.email, subject: @order.quantity + " product(s) ordered by " + @order.supplier.name + " have been marked as returned from " + @user.name
  end


  def cancel_order(order, current_user)
    @order = order
    @user = current_user

    mail to: @order.supplier.email, subject: "An order regarding " + @order.quantity + " product(s) ordered by " + @order.supplier.name + " has been canceled from " + @user.name
  end

end
