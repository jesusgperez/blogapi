module Secured
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