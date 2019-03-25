class AddExpireAtToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :expire_at, :date
  end
end
