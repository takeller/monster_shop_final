class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.new
    order.save
      cart_discounts = cart.find_applicable_discounts
      cart.items.each do |item|
        if cart_discounts && cart_discounts.include?(item.id)
          item_price = item.price * ((100 - cart_discounts[item.id])/100)
        else
          item_price = item.price
        end
        order.order_items.create({
          item: item,
          quantity: cart.count_of(item.id),
          price: item_price
          })
      end
    session.delete(:cart)
    flash[:notice] = "Order created successfully!"
    redirect_to '/profile/orders'
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end
end
