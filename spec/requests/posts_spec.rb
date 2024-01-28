require 'rails_helper'

RSpec.describe PostsController, type: :request do
  include Devise::Test::IntegrationHelpers

  before(:each) do
    @user = User.first
    @post = Post.create!(title: 'Test Post', text: 'This is a test post', author: @user)
    # Create some comments and likes for the post if necessary
    sign_in @user # Sign in the user
  end

  let(:user) { User.first }

  describe 'GET #index' do
    before { get user_posts_path(user_id: user.id) }

    it 'returns a successful response' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    it 'includes correct placeholder text in the response body' do
      expect(response.body).to include('All Posts')
    end
  end

  describe 'GET #show' do
    before { get user_post_path(user_id: user.id, id: @post.id) }

    it 'returns a successful response' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end

    it 'includes correct placeholder text in the response body' do
      expect(response.body).to include('Post Details')
    end
  end
end
