require 'rails_helper'

describe BulkDiscount, type: :model do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  # describe "Class Methods" do
  #
  #   before :each do
  #     @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
  #     @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
  #     @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
  #     @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 2 )
  #     @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 6 )
  #     @cart = Cart.new({
  #       @ogre.id.to_s => 1,
  #       @giant.id.to_s => 2
  #       })
  #     @discount1 = BulkDiscount.create!(name: "5 for 5", item_threshold: 5, discount: 5, merchant_id: @brian.id)
  #   end
  #
  #   it 'Meets_Criteria?' do
  #     contents = {
  #       "1" => 1,
  #       "2" => 2,
  #       "3" => 5
  #     }
  #
  #     expect(BulkDiscount.meets_criteria?(contents)).
  #   end
  # end
end
