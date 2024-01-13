class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]

  rescue_from Exception do |e|
    render json: {error: e.message}, status: :internal_server_error
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: {error: e.message}, status: :unprocessable_entity
  end

  # GET /posts
  def index
    @posts = Post.where(published: true)
    if !params[:search].nil? && params[:search].present?
      @posts = PostsSearchService.search(@posts, params[:search])
    end
    # This includes will solve the N + 1 query problem
    render json: @posts.includes(:user), status: :ok
  end

  # GET /posts/{id}
  def show
    @post = Post.find(params[:id])

    if @post.published?
      render json: @post, status: :ok
      return
    end

    if Current.user && @post.user_id == Current.user.id
      render json: @post, status: :ok
      return
    end

    render json: {error: 'Not found'}, status: :not_found
  end

  # POST /posts
  def create
    @post = Current.user.posts.create!(create_params)
    render json: @post, status: :created
  end

  # PUT /posts
  def update
    @post = Current.user.posts.find(params[:id])
    @post.update!(update_params)
    render json: @post, status: :ok
  end

  private

  def create_params
    params.require(:post).permit(:title, :content, :published, :user_id)
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end

  def authenticate_user!
    token_regex = /Bearer (\w+)/
    headers = request.headers
    unless headers['Authorization'].present?
      render json: {error: 'Unauthorized'}, status: :unauthorized
      return
    end

    auth = headers['Authorization'].match(token_regex)
    if auth.nil?
      render json: {error: 'Unauthorized'}, status: :unauthorized
      return
    end
    
    user = User.find_by_auth_token(auth[1])
    if user.nil?
      render json: {error: 'Unauthorized'}, status: :unauthorized
      return
    end

    Current.user = user
  end
end