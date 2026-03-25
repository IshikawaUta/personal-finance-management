require './app'
require './middleware/auth_middleware'

use AuthMiddleware
run App.new
