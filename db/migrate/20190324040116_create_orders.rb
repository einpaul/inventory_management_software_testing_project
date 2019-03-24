class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :quantity
      t.integer :status
      t.integer :expire_at
      t.integer :product_id
      t.integer :supplier_id

      t.timestamps
    end
  end
end
