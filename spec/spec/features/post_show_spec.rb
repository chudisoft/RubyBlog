require 'rails_helper'

RSpec.describe 'Post Show Page', type: :feature do
  let(:user) { User.first }
  let(:post) { user.posts.first }
  before do
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
