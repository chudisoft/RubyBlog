require 'rails_helper'

RSpec.describe 'Post Show Page', type: :feature do
  before(:each) do
    @user = User.last
    @post = Post.create!(title: 'Test Post', text: 'This is a test post', author: @user)
    # Create some comments and likes for the post if necessary
  end

  let(:userTest) { @user }
  let(:user) { User.first }
  let(:post) { user.posts.first }

  before do
    # Simulate user login if necessary
    visit new_user_session_path
    fill_in 'Email', with: userTest.email
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    visit user_post_path(user, post)
  end

  it 'shows the post and comments details' do
    expect(page).to have_content(post.title)
    expect(page).to have_content(" by #{post.author.name}")
    expect(page).to have_content("Comments: #{post.comments.count}")
    expect(page).to have_content("Likes: #{post.likes.count}")
    expect(page).to have_content(post.text)

    post.comments.each do |comment|
      expect(page).to have_content(comment.user.name)
      expect(page).to have_content(comment.text)
    end
  end
end
