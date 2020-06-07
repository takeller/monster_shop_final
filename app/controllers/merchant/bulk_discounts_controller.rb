class Merchant::BulkDiscountsController < Merchant::BaseController

  def index
    @bulk_discounts = BulkDiscount.all
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

private

  def discount_params
    params.require(:discount).permit(:name, :item_threshold, :discount)
  end
end
