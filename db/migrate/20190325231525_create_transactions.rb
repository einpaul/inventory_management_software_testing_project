class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :transaction_id
      t.integer :product_id
      t.integer :supplier_id
      t.integer :quantity

      t.timestamps
    end
  end
end
