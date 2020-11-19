# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

merchants = Merchant.create!([{username: "coolperson", email: "coolperson@cool.com", provider:
    "github", uid: "832943"}])
products = Product.create!([{ name: "Furby", description: "A toy from the 90s", price: 9.99,
                              stock: 200, merchant: merchants.first}])
