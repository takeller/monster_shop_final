require 'rails_helper'

describe BulkDiscount, type: :model do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end
end
