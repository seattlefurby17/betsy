# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

merchants = Merchant.create!([{ username: "coolperson", email: "coolperson@cool.com", provider: "github", uid: "832943"},
                              { username: "testuser", email: "test@test.com", provider: "github", uid: "34289"},
                              { username: "wintergreen", email: "winter@green.com", provider: "github", uid: "34289"},
                              { username: "sunshinerainbow", email: "sunshine@rainbow.com", provider: "github", uid: "010183"},
                              { username: "awesomesauce", email: "awesome@sauce.com", provider: "github", uid: "97467"}])

products = Product.create!([{ name: "Furby", description: "A toy from the 90s", price: 9.99,
                              stock: 200, merchant: merchants.first},
                            { name: "Tamagotchi", description: "The Tamagotchi is a handheld digital pet that was created in Japan. ", price: 15.30,
                              stock: 150, merchant: Merchant.find_by(username: "sunshinerainbow")},
                            { name: "Poo Chi", description: "Poo-Chi, one of the first generations of robopet toys, is a robot dog designed by Samuel James Lloyd and Matt Lucas, ",
                              price: 5.30, stock: 100, merchant: Merchant.find_by(username: "testuser")},
                            { name: "Neopets", description: "Users can own virtual pets, and buy virtual items for them using one of two virtual currencies",
                              price: 2.00, stock: 100, merchant: Merchant.find_by(username: "wintergreen")},
                            { name: "Vintage Troll Doll", description: "They were first created in 1959 and became one of the United States' biggest toy fads in the early 1960s.",
                              price: 5.00, stock: 100, merchant: Merchant.find_by(username: "awesomesauce")}
                           ])
