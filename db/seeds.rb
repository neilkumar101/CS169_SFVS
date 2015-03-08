# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create({email: 'admin@hostname.com', password: 'admin123', admin: true}, :without_protection => true)
User.create({email: 'user2@hostname.com', password: 'user1234', admin: false}, :without_protection => true)