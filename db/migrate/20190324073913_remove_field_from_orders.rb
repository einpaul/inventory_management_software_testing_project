class RemoveFieldFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :expire_at
  end
end
