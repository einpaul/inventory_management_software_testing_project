10.times do
  Category.create(
    name: Faker::Commerce.department)
end



1000.times do
  Product.create(
    name: Faker::Commerce.product_name,
    quantity: Faker::Number.number(3),
    remaining_quantity: Faker::Number.number(3),
    category_id: Category.order('RANDOM()').first.id,
    code: Faker::Code.npi,
    description: Faker::Lorem.sentence )

end



Category.order('RANDOM()').first.id

50.times do
  Supplier.create(
    name: Faker::Company.name,
    email: Faker::Internet.email,
    phone: Faker::Number.number(10),
    status: ['active', 'disabled', 'revoked'].sample
    )

end


2500.times do
  Order.create(
    quantity: Faker::Number.number(3),
    status: ['true', 'false'].sample ,
    expire_at: Faker::Date.between(Date.today, 5.year.from_now),
    product_id: Product.order('RANDOM()').first.id,
    supplier_id: Supplier.order('RANDOM()').first.id
    )
end



3000.times do
  Transaction.create(
    transaction_id: Faker::Code.asin,
    quantity: Faker::Number.number(3) ,
    product_id: Product.order('RANDOM()').first.id,
    supplier_id: Supplier.order('RANDOM()').first.id
    )
end






