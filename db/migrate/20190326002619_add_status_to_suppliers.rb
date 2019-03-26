class AddStatusToSuppliers < ActiveRecord::Migration[5.1]
  def change
    add_column :suppliers, :status, :integer
  end
end
