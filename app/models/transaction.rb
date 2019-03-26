class Transaction < ApplicationRecord

  #associations

  belongs_to :supplier
  belongs_to :product

  before_create :set_defaults

  #validations

  validates :quantity, presence: true, numericality: true

  private

  def set_defaults
    self.transaction_id = generate_transaction_id
  end

  def generate_transaction_id
    loop do
      txn_id = rand.to_s[2..13]
      break txn_id unless Transaction.exists?(transaction_id: txn_id)
    end
  end

end
