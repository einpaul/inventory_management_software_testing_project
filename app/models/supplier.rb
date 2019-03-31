class Supplier < ApplicationRecord

  #associations
  has_many :orders
  has_many :products, through: :orders
  has_many :transactions
  has_many :reviews


  enum status: %w(active disabled revoked)

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true, numericality: true

  before_create :set_defaults

  private

  def set_defaults
    self.status = 'active'
  end
end
