# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "csv"

# CSV.foreach('db/category.csv') do |record|
#   Category.create(name: record[0], parent_id: record[1])
# end

# CSV.foreach('db/brand.csv') do |record|
#   Brand.create(name: record[0], brand_group_id: record[1])
# end

# CSV.foreach('db/brand_group.csv') do |record|
#   BrandGroup.create(name: record[0])
# end

# CSV.foreach('db/size.csv') do |record|
#   Size.create(name: record[0])
# end

# CSV.foreach('db/item.csv') do |record|
#   Item.create(name: record[0], price: record[1], description: record[2], condition: record[3], shipping_fee: record[4], shipping_from: record[5], days_before_shipping: record[6], shipping_method: record[7], status: record[8], brand: record[9], category_id: record[10], user_id: record[11], size_id: record[12])
# end
