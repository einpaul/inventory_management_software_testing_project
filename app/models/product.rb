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


  def average_rating_per_product
    return 'No Rated Yet' if self.reviews.empty?
    rating_total = self.reviews.sum(:rating)
    reviews_count = self.reviews.count
    average_rating = (rating_total / reviews_count).to_f
  end

end
