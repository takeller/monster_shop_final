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
      grand_total += subtotal_of(item_id)
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    applicable_discounts = find_applicable_discounts
    subtotal = @contents[item_id.to_s] * Item.find(item_id).price
    if applicable_discounts && applicable_discounts[item_id.to_i]
      discount_to_apply = applicable_discounts[item_id.to_i]
      subtotal = apply_discount(subtotal, discount_to_apply)
    else
      subtotal
    end
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
    return nil if find_merchant_discounts.nil?
    discounts = find_merchant_discounts
    applicable_discounts = {}
    @contents.each do |item_id, quantity|
      item = Item.find(item_id)
      max_discount = discounts.where("merchant_id = #{item.merchant_id} AND item_threshold <= #{quantity}").maximum(:discount)
      applicable_discounts[item_id.to_i] = max_discount unless max_discount.nil?
    end
    return nil if applicable_discounts.empty?
    applicable_discounts
  end

  def apply_discount(subtotal, discount)
    subtotal * ((100 - discount)/100.0)
  end

end
