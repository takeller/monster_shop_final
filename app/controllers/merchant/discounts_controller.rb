class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = BulkDiscount.all
  end

end
