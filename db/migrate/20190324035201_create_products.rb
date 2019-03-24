class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :category_id
      t.integer :quantity
      t.string :code
      t.integer :remaining_quantity

      t.timestamps
    end
  end
end
