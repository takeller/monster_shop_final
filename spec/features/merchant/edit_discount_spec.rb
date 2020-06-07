require 'rails_helper'

describe "Edit Merchant Discount" do
  describe "As a Merchant" do

    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount1 = BulkDiscount.create!(name: "5 for 5", item_threshold: 5, discount: 5, merchant_id: @merchant_1.id)
      @discount2 = BulkDiscount.create!(name: "5 for 10", item_threshold: 10, discount: 5, merchant_id: @merchant_1.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I can click a link to an edit discount page" do
      visit "/merchant/bulk_discounts"

      within("#discount-#{@discount1.id}") do
        click_link "Edit Discount"
      end

      expect(current_path).to eq("/merchant/bulk_discounts/#{@discount1.id}/edit")
    end

    it "I can update a discount's information" do
      visit "/merchant/bulk_discounts/#{@discount1.id}/edit"

      fill_in "Name", with: "5 for 7"
      fill_in :bulk_discount_item_threshold, with: 7
      click_button "Update Discount"

      expect(current_path).to eq("/merchant/bulk_discounts")

      within("#discount-#{@discount1.id}") do
        expect(page).to have_content("Name: 5 for 7")
        expect(page).to have_content("Item Threshold: 7")
        expect(page).to have_content("Discount Amount: 5")
      end

    end
  end
end
