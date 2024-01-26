require 'rails_helper'

RSpec.describe 'User Post Index Page', type: :feature do
  let(:user) { User.first }
  before do
    visit user_posts_path(user)
  end

  it 'shows the user and posts details' do
    expect(page).to have_selector("img[src*='#{user.photo}']")
    expect(page).to have_content(user.name)
    expect(page).to have_content("Number of posts: #{user.posts.count}")

    user.posts.each do |post|
      expect(page).to have_content(post.title)
      expect(page).to have_content(post.text.truncate(100)) # Assuming you show a truncated body
      expect(page).to have_content("Comments: #{post.comments.count}")
      expect(page).to have_content("Likes: #{post.likes.count}")
      post.recent_comments.each do |comment|
        expect(page).to have_content(comment.user.name)
        expect(page).to have_content(comment.text)
        unique_comment_content = "#{comment.user.name}: #{comment.text}"
        expect(page).to have_content(unique_comment_content)
      end
    end
  end

  it 'redirects to a post show page when a post is clicked' do
    post = user.posts.first
    click_on post.title
    expect(current_path).to eq(user_post_path(user, post))
  end

  it 'shows pagination if there are more posts than fit on the view' do
    expect(page).to have_selector('.pagination')
    expect(page).to have_link('2') # Checking for a link to the second page
  end
end
