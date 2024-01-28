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
User.destroy_all
Post.destroy_all
Comment.destroy_all
Like.destroy_all

# Create 5 unique users
5.times do |i|
  User.create(
    name: Faker::Name.unique.name,   # Ensures that the generated name is unique
    photo: "https://robohash.org/#{i}?size=200x200", # Uses a URL with a unique parameter
    bio: Faker::Lorem.sentence
  )
end

# Resetting the Faker unique generator after creating unique names
Faker::Name.unique.clear

# Create unique posts, comments, and likes
User.all.each do |user|
  # Create a certain number of posts for each user
  3.times do
    post = user.posts.create(
      title: Faker::Lorem.unique.sentence, # Ensures unique titles for posts
      text: Faker::Lorem.paragraph
    )

    # Resetting the Faker unique generator after creating unique titles
    Faker::Lorem.unique.clear

    # Add unique comments to each post
    10.times do
      post.comments.create(
        user: User.all.sample,  # Randomly selects a user to be the commenter
        text: Faker::Lorem.sentence
      )
    end

    # Add likes to each post
    User.all.sample(5).each do |liker| # Randomly selects 5 unique users to like the post
      post.likes.create(user: liker)
    end
  end
end
