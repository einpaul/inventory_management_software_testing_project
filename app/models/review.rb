class Review < ApplicationRecord

  #associations
  belongs_to :product, optional: true
  belongs_to :supplier, optional: true
  belongs_to :user, optional: true

end
