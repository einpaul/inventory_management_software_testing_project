class Review < ApplicationRecord

  #associations
  belongs_to :product, optional: true
  belongs_to :supplier, optional: true
  belongs_to :user, optional: true


  def self.average_product_rating
    product_ratings = Review.where.not(product_id: nil)
    product_rating_sum = product_ratings.sum(:rating)
    total_product_ratings = product_ratings.count
    average_rating = (product_rating_sum / total_product_ratings).to_f
  end

  def self.average_supplier_rating
    supplier_ratings = Review.where.not(supplier_id: nil)
    supplier_rating_sum = supplier_ratings.sum(:rating)
    total_supplier_ratings = supplier_ratings.count
    average_rating = (supplier_rating_sum / total_supplier_ratings).to_f
  end

end


