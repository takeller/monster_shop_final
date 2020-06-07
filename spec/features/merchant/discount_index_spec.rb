require 'rails_helper'

describe "Merchant Discount Index" do
  describe "As a Merchant" do

    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount1 = BulkDiscount.create!(name: "5 for 5", item_threshold: 5, discount: 5, merchant_id: @merchant_1.id)
      @discount2 = BulkDiscount.create!(name: "5 for 10", item_threshold: 10, discount: 5, merchant_id: @merchant_1.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I can click a link to a discount index page" do
      visit "/merchant"

      click_link "My Discounts"

      expect(current_path).to eq("/merchant/discounts")
    end

    it "I can see all of my discounts" do
      visit "/merchant/discounts"

      within("#discount-#{@discount1.id}") do
        expect(page).to have_content("Name: #{@discount1.name}")
        expect(page).to have_content("Item Threshold: #{@discount1.item_threshold}")
        expect(page).to have_content("Discount Amount: #{@discount1.discount}")
      end

      within("#discount-#{@discount2.id}") do
        expect(page).to have_content("Name: #{@discount2.name}")
        expect(page).to have_content("Item Threshold: #{@discount2.item_threshold}")
        expect(page).to have_content("Discount Amount: #{@discount2.discount}")
      end
    end
  end
end
