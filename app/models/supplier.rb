class Supplier < ApplicationRecord

  #associations
  has_many :orders
  has_many :products, through: :orders

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
end
