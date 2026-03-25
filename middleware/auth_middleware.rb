require 'jwt'
require 'dotenv'

Dotenv.load

class AuthMiddleware
  def initialize(app)
    @app = app
    @jwt_secret = ENV['JWT_SECRET']
  end

  def call(env)
    # Skip auth for landing page, login, signup
    return @app.call(env) if ['/', '/api/login', '/api/signup'].include?(Rack::Request.new(env).path)
    
    # Check Authorization header
    auth_header = env['HTTP_AUTHORIZATION']
    if auth_header && auth_header.start_with?('Bearer ')
      token = auth_header.split(' ').last
      begin
        payload = JWT.decode(token, @jwt_secret, true, { algorithm: 'HS256' })[0]
        env['current_user_id'] = payload['user_id']
        @app.call(env)
      rescue JWT::DecodeError
        [401, { 'Content-Type' => 'application/json' }, [{ error: 'Unauthorized: Invalid token' }.to_json]]
      end
    else
      [401, { 'Content-Type' => 'application/json' }, [{ error: 'Unauthorized: Header missing' }.to_json]]
    end
  end
end
