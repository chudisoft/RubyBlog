require 'rails_helper'

RSpec.describe 'User Index Page', type: :feature do
  before do
    visit users_path
  end

  it 'shows all users with their username and profile picture' do
    User.all.each do |user|
      expect(page).to have_content(user.name)
      expect(page).to have_selector("img[src*='#{user.photo}']")
    end
  end

  it 'shows the number of posts each user has written' do
    User.all.each do |user|
      expect(page).to have_content("Number of posts: #{user.posts.count}")
    end
  end

  it 'redirects to user show page on clicking a user' do
    user = User.first
    first('a', text: user.name).click
    expect(current_path).to eq(user_path(user))
  end
end
