class CreateBulkDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bulk_discounts do |t|
      t.string :name
      t.integer :item_threshold
      t.float :discount
      t.references :merchant, foreign_key: true
      t.timestamps
    end
  end
end
