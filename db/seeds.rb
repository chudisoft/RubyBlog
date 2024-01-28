# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear existing data
Like.destroy_all
Comment.destroy_all
Post.destroy_all
User.destroy_all

# Create an admin user
User.create(
  name: 'Admin User',
  photo: Faker::Avatar.image(slug: Faker::Lorem.unique.word, size: "200x200", format: "png", set: "set1"),
  bio: Faker::Lorem.sentence,
  email: 'admin@email.com',
  password: '123456', # or any other default password
  password_confirmation: '123456', # ensure this matches the password
  confirmed_at: Time.now, # To bypass the confirmation email
  posts_counter: 0,
  role: 'admin'
)
Post.destroy_all
User.destroy_all

# Create an admin user
User.create(
  name: 'Admin User',
  photo: Faker::Avatar.image(slug: Faker::Lorem.unique.word, size: "200x200", format: "png", set: "set1"),
  bio: Faker::Lorem.sentence,
  email: 'admin@email.com',
  password: '123456', # or any other default password
  password_confirmation: '123456', # ensure this matches the password
  confirmed_at: Time.now, # To bypass the confirmation email
  posts_counter: 0,
  role: 'admin'
)

# Create 5 random users
5.times do
  user = User.new(
    name: Faker::Name.name,
    photo: Faker::Avatar.image(slug: Faker::Lorem.unique.word, size: "200x200", format: "png", set: "set1"),
    bio: Faker::Lorem.sentence,
    email: Faker::Internet.unique.email,
    password: '123456', # or any other default password
    password_confirmation: '123456', # ensure this matches the password
    confirmed_at: Time.now, # To bypass the confirmation email
    posts_counter: 0
  )

  user.skip_confirmation! # Skip sending confirmation email
  user.save!
end

Faker::Internet.unique.clear # Clear the Faker unique generator


# Resetting the Faker unique generator after creating unique titles
Faker::Lorem.unique.clear

# Create 15 random posts with 10 random comments and 5 random likes for each post
35.times do
  post = Post.create(
    author: User.all.sample,
    title: Faker::Lorem.sentence,
    text: Faker::Lorem.paragraph,
    comments_counter: 0,
    likes_counter: 0
  )

  # Resetting the Faker unique generator after creating unique items
  Faker::Lorem.unique.clear

  10.times do
    Comment.create(
      user: User.all.sample,
      post: post,
      text: Faker::Lorem.sentence
    )
  end
  # Add likes to each post
  User.all.sample(5).each do |liker| # Randomly selects 5 unique users to like the post
    post.likes.create(user: liker)
  end
end

puts "Seed Completed"
puts "Added Users: #{User.count}"
puts "Added Posts: #{Post.count}"
