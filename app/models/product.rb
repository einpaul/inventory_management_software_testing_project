class Product < ApplicationRecord

  #associations
  has_many :orders
  has_many :suppliers, through: :orders
  has_many :transactions
  belongs_to :category
  has_many :reviews

  validates :name, presence: true
  validates :quantity, presence: true, numericality: true
  validates :code, presence: true
  # validates :category, presence: true
end
