class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :body
      t.integer :product_id
      t.integer :supplier_id
      t.integer :user_id

      t.timestamps
    end
  end
end
