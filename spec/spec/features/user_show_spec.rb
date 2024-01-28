require 'rails_helper'

RSpec.describe 'User Show Page', type: :feature do
  let(:user) { User.first }
  before do
    visit user_path(user)
  end

  it 'shows the user details' do
    expect(page).to have_selector("img[src*='#{user.photo}']")
    expect(page).to have_content(user.name)
    expect(page).to have_content("Number of posts: #{user.posts.count}")
    expect(page).to have_content(user.bio)
  end

  it 'shows the first 3 posts of the user' do
    user.posts.limit(3).each do |post|
      expect(page).to have_content(post.title)
    end
  end

  it 'redirects to the posts index page when view all posts button is clicked' do
    click_on 'View all Posts'
    expect(current_path).to eq(user_posts_path(user))
  end

  it 'redirects to a post show page when a post is clicked' do
    post = user.posts.first
    click_on post.title
    expect(current_path).to eq(user_post_path(user, post))
  end
end
