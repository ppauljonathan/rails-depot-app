#---
# Excerpted from "Agile Web Development with Rails 6",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rails6 for more book information.
#---
# encoding: utf-8
Product.delete_all
Product.create!(title: 'Docker for Rails Developers',
  description: 'Build, Ship, and Run Your Applications Everywhere',
  image_url: 'ridocker.jpg',
  permalink: 'abc-def-ghi',
  price: 38.00)
# . . .
Product.create!(title: 'Build Chatbot Interactions',
  description:'Responsive, Intuitive Interfaces with Ruby',
  image_url: 'dpchat.jpg',
  permalink: '12-54-213',
  price: 20.00)
# . . .

Product.create!(title: 'Programming Crystal',
  description:'Create High-Performance, Safe, Concurrent Apps',
  image_url: 'crystal.jpg',
  permalink: 'x-y-z',
  price: 40.00)

User.create!(name: 'paul', password: 'secret', email: 'admin@depot.com')