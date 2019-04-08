class Category < ApplicationRecord
  #assocaitions
  has_many :products

  def product_quantity
    self.products.sum(:remaining_quantity)
  end
end
