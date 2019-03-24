class Product < ApplicationRecord

  #associations
  has_many :orders
  has_many :suppliers, through: :orders

  validates :name, presence: true
  # validates :category, presence: true
end
