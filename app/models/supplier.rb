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

  def average_rating_per_supplier
    return 'No Rated Yet' if self.reviews.empty?
    rating_total = self.reviews.sum(:rating)
    reviews_count = self.reviews.count
    average_rating = (rating_total / reviews_count).to_f
  end

  private

  def set_defaults
    self.status = 'active'
  end
end
