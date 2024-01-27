require 'rails_helper'

RSpec.describe 'User Index Page', type: :feature do
  before(:each) do
    @user = User.last
    @post = Post.create!(title: 'Test Post', text: 'This is a test post', author: @user, comments_counter: 0)
    # Create some comments and likes for the post if necessary
  end

  let(:userTest) { @user }
  let(:user) { User.first }

  before do
    # Simulate user login if necessary
    visit new_user_session_path
    fill_in 'Email', with: userTest.email
    fill_in 'Password', with: '123456'
    click_on 'Log in'

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
