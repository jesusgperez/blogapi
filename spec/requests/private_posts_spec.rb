require 'rails_helper'

RSpec.describe "Posts with auth", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:user_post) { create(:post, user_id: user.id) }
  let!(:other_user_post) { create(:post, user_id: other_user.id, published: true) }
  let!(:other_user_post_draft) { create(:post, user_id: other_user.id, published: false) }
  let!(:auth_headers) {{'Authorization' => "Bearer #{user.auth_token}"}}
  let!(:other_auth_headers) {{'Authorization' => "Bearer #{other_user.auth_token}"}}
  let!(:create_params) {{"post" => {"title" => "title", "content" => "content", "published" => true}}}
  let!(:update_params) {{"post" => {"title" => "title", "content" => "content", "published" => true}}}

  # Authorization: Bearer <token>

  describe "GET /posts/{id}" do
    context "with valid auth" do
      context "when requesting other's author post" do
        context "when post is public" do
          before { get "/posts/#{other_user_post.id}", headers: auth_headers }
          context "payload" do
            subject { payload }
            it {is_expected.to include(:id)}
          end
          context "response" do
            subject { response }
            it {is_expected.to have_http_status(:ok)}
          end
        end
        context "when post is draft" do
          before { get "/posts/#{other_user_post_draft.id}", headers: auth_headers }
          context "payload" do
            subject { payload }
            it {is_expected.to include(:error)}
          end
          context "response" do
            subject { response }
            it {is_expected.to have_http_status(:not_found)}
          end
        end
      end
      context "when requesting user's post" do
      end
    end
  end

  describe "POST /posts" do
    # with auth -> Crear
    context "with valid auth" do
      before { post "/posts", params: create_params, headers: auth_headers }
      
      context "payload" do
        subject { payload }
        it { is_expected.to include(:id, :title, :content, :published, :author) }
      end
      
      context "response" do
        subject { response }
        it { is_expected.to have_http_status(:created) }
      end
    end
    # w/o auth -> 401
    
    context "without auth" do
      before { post "/posts", params: create_params }
      
      context "payload" do
        subject { payload }
        it { is_expected.to include(:error) }
      end
      
      context "response" do
        subject { response }
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end
  end
  
  describe "PUT /posts" do
    # with auth
    # update self post
    # not update other people's posts
    context "with valid auth" do
      context "when updating user's post" do
        before { put "/posts/#{user_post.id}", params: update_params, headers: auth_headers }
        context "payload" do
          subject { payload }
          it { is_expected.to include(:id, :title, :content, :published, :author) }
          it { expect(payload[:id]).to eq(user_post.id) }
        end

        context "response" do
          subject { response }
          it { is_expected.to have_http_status(:ok) }
        end
      end
      
      context "when updating other poeple's post" do
        before { put "/posts/#{other_user_post.id}", params: update_params, headers: auth_headers }
        context "payload" do
          subject { payload }
          it { is_expected.to include(:error) }
        end

        context "response" do
          subject { response }
          it { is_expected.to have_http_status(:not_found) }
        end
      end
    end

    # w/o auth -> 401
    context "without auth" do
      before { put "/posts/#{user_post.id}", params: create_params }

      context "payload" do
        subject { payload }
        it { is_expected.to include(:error) }
      end
      
      context "response" do
        subject { response }
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end
  end
  
  # it "should return OK"  do
  #   get '/posts'
  #   payload = JSON.parse(response.body)
  #   expect(payload).to be_empty
  #   expect(response).to have_http_status(200)
  # end
  
  private

  def payload
    JSON.parse(response.body).with_indifferent_access
  end
end