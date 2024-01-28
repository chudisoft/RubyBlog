require 'rails_helper'

RSpec.describe UsersController, type: :request do
  include Devise::Test::IntegrationHelpers

  before(:each) do
    @user = User.first
    @post = Post.create!(title: 'Test Post', text: 'This is a test post', author: @user)
    # Create some comments and likes for the post if necessary
    sign_in @user # Sign in the user
  end

  let(:user) { User.first }

  describe 'GET #index' do
    before { get users_path }

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    it 'includes the correct placeholder text in the response body' do
      expect(response.body).to include('All Users')
    end
  end

  describe 'GET #show' do
    before { get user_path(user.id) }

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end

    it 'includes the correct placeholder text in the response body' do
      expect(response.body).to include('User Details')
    end
  end
end
