class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    # if find_discount
    # else
    @contents[item_id.to_s] * Item.find(item_id).price
    # end
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def find_merchants
    item_ids = @contents.keys.map { |item_id| item_id.to_i }
    Item.select(:merchant_id).where(id: item_ids).distinct.pluck(:merchant_id)
  end

  def find_merchant_discounts
    merchant_ids = find_merchants
    discounts = BulkDiscount.where(merchant_id: merchant_ids)
    return nil if discounts.count == 0
    discounts
  end

  def find_applicable_discounts
    discounts = find_merchant_discounts
    applicable_discounts = {}
    @contents.each do |item_id, quantity|
      item = Item.find(item_id)
      item_discounts = discounts.where("merchant_id = #{item.merchant_id} AND item_threshold <= #{quantity}")
      applicable_discounts[item_id.to_i] = item_discounts if item_discounts.count > 0
    end
    return nil if applicable_discounts.empty?
    applicable_discounts
  end
end
