class Merchant::BulkDiscountsController < Merchant::BaseController

  def index
    @bulk_discounts = BulkDiscount.all
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    bulk_discount = merchant.bulk_discounts.new(discount_params)

    if bulk_discount.save
      flash[:notice] = "You have created a new discount"
      redirect_to merchant_bulk_discounts_path
    else
      flash[:notice] = "You were unable to create a new discount"
      redirect_back fallback_location: merchant_bulk_discounts_path
    end
  end

private

  def discount_params
    params.require(:bulk_discount).permit(:name, :item_threshold, :discount)
  end
end
