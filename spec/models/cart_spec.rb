require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 2 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 6 )
      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
      @discount1 = BulkDiscount.create!(name: "5 for 5", item_threshold: 5, discount: 5, merchant_id: @brian.id)
      @discount2 = BulkDiscount.create!(name: "5 for 10", item_threshold: 10, discount: 5, merchant_id: @megan.id)
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 1
        })
    end

    it '.count' do
      expect(@cart.count).to eq(3)
    end

    it '.items' do
      expect(@cart.items).to eq([@ogre, @giant])
    end

    it '.grand_total' do
      expect(@cart.grand_total).to eq(120)

      4.times do
        @cart.add_item(@hippo.id.to_s)
      end

      expect(@cart.grand_total).to eq(320)

      @cart.add_item(@hippo.id.to_s)

      expect(@cart.grand_total).to eq(357.5)

      BulkDiscount.create!(name: "25 for 5", item_threshold: 5, discount: 25, merchant_id: @brian.id)

      expect(@cart.grand_total).to eq(307.5)
    end

    it '.count_of()' do
      expect(@cart.count_of(@ogre.id)).to eq(1)
      expect(@cart.count_of(@giant.id)).to eq(2)
    end

    it '.subtotal_of()' do
      expect(@cart.subtotal_of(@ogre.id)).to eq(20)
      expect(@cart.subtotal_of(@giant.id)).to eq(100)

      5.times do
        @cart.add_item(@hippo.id.to_s)
      end

      expect(@cart.subtotal_of(@hippo.id)).to eq(237.5)
    end

    it '.limit_reached?()' do
      expect(@cart.limit_reached?(@ogre.id)).to eq(false)
      expect(@cart.limit_reached?(@giant.id)).to eq(true)
    end

    it '.less_item()' do
      @cart.less_item(@giant.id.to_s)

      expect(@cart.count_of(@giant.id)).to eq(1)
    end

    it '.find_merchant_discounts' do
      expect(@cart.find_merchant_discounts).to eq([@discount2])

      @cart.add_item(@hippo.id.to_s)

      expect(@cart.find_merchant_discounts).to eq([@discount1, @discount2])
    end

    it '.find_merchants' do
      expect(@cart.find_merchants).to eq([@megan.id])

      @cart.add_item(@hippo.id.to_s)

      expect(@cart.find_merchants).to eq([@megan.id, @brian.id])
    end

    it '.find_applicable_discounts' do
      expect(@cart.find_applicable_discounts).to eq(nil)

      5.times do
        @cart.add_item(@hippo.id.to_s)
      end

      expect(@cart.find_applicable_discounts).to eq({@hippo.id =>5})
    end

    it '.apply_discount' do
      expect(@cart.apply_discount(250, 5)).to eq(237.5)
      expect(@cart.apply_discount(1000, 5)).to eq(950)
    end
  end
end
