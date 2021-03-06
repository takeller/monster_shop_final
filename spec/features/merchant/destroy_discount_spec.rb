require 'rails_helper'

describe "Destroy Merchant Discount" do
  describe "As a Merchant" do

    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount1 = BulkDiscount.create!(name: "5 for 5", item_threshold: 5, discount: 5, merchant_id: @merchant_1.id)
      @discount2 = BulkDiscount.create!(name: "5 for 10", item_threshold: 10, discount: 5, merchant_id: @merchant_1.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I can destroy a discount" do
      visit merchant_bulk_discounts_path

      within("#discount-#{@discount1.id}") do
        click_link "Destroy Discount"
      end

      expect(current_path).to eq(merchant_bulk_discounts_path)

      expect(page).to_not have_content(@discount1.name)
    end
  end
end
