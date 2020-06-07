require 'rails_helper'

describe "New Merchant Discount" do
  describe "As a Merchant" do

    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount1 = BulkDiscount.create!(name: "5 for 5", item_threshold: 5, discount: 5, merchant_id: @merchant_1.id)
      @discount2 = BulkDiscount.create!(name: "5 for 10", item_threshold: 10, discount: 5, merchant_id: @merchant_1.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I can click a link to a new discount page" do
      visit "/merchant/bulk_discounts"

      click_link "New Discount"

      expect(current_path).to eq("/merchant/bulk_discounts/new")
    end

    it "I can create discount for a merchant" do
      name = "10 for 10"
      item_threshold = 10
      discount = 10

      visit "merchant/bulk_discounts/new"

      fill_in "Name", with: name
      fill_in :bulk_discount_item_threshold, with: item_threshold
      fill_in "Discount", with: discount
      click_button "Create Discount"

      last_discount = BulkDiscount.last

      expect(current_path).to eq("/merchant/bulk_discounts")
      within("#discount-#{last_discount.id}") do
        expect(page).to have_content("Name: #{last_discount.name}")
        expect(page).to have_content("Item Threshold: #{last_discount.item_threshold}")
        expect(page).to have_content("Discount Amount: #{last_discount.discount}")
      end

    end
  end
end
