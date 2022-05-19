# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
user = User.create!(email: 'scott@test.com', password: '12345678', uuid: SecureRandom.uuid)
paste = Paste.create!(name: 'Private Code snippet', content: 'some code here', uuid: SecureRandom.uuid, user_id: user.id, private: true)
paste = Paste.create!(name: 'Public Code snippet', content: 'some code here', uuid: SecureRandom.uuid, user_id: user.id, private: false)