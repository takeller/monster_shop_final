require 'rails_helper'
include ActionView::Helpers::NumberHelper

describe 'As a user' do
  describe 'When I go to checkout my cart' do

    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 25 )
    end

    it "I see any discounts automatically applied to my order total" do
      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit '/cart'

      within "#item-#{@hippo.id}" do
        expect(page).to have_content("Subtotal: #{number_to_currency(@hippo.price * 1)}")

        18.times do
          click_button('More of This!')
        end

        expect(page).to have_content("Subtotal: #{number_to_currency(@hippo.price * 19)}")

        click_button('More of This!')

        expect(page).to_not have_content("Subtotal: #{number_to_currency(@hippo.price * 20)}")

        expect(page).to have_content("Subtotal: #{number_to_currency(@hippo.price * 20 * 0.95)}")
      end
    end
  end
end
