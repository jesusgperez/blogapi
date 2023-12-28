require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
		before { get '/posts' }
    
		it "should return OK"  do
			payload = JSON.parse(response.body)
			expect(payload).to be_empty
      expect(response).to have_http_status(200)
		end
  end

  describe "with data in the DB" do
    let!(:posts) { create_list(:post, 10, published: true) }
    before { get '/posts' }
    it "should return all published posts"  do
      payload = JSON.parse(response.body)
      
      expect(response).to have_http_status(200)
      expect(payload.size).to eq(posts.size)
    end
	end
  
  describe "GET /posts/{id}" do
    let!(:post) { create(:post) }
    before { get "/posts/#{post.id}" }

    it "should return a post"  do
      payload = JSON.parse(response.body)

      expect(payload).to_not be_empty
      expect(payload["id"]).to eq(post.id)
      expect(response).to have_http_status(200)
    end
  end
end
