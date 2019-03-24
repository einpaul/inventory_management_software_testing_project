class Order < ApplicationRecord

  belongs_to :product
  belongs_to :supplier

  validates :quantity, presence: true
  validates :expire_at, presence: true
  # validates :product_id, presence: true
  # validates :member_id, presence: true

end
