require 'rack'
require 'json'
require 'jwt'
require 'dotenv'
require_relative 'models/user'
require_relative 'models/account'
require_relative 'models/transaction'
require_relative 'models/category'
require_relative 'models/budget'
require_relative 'models/goal'
require_relative 'middleware/auth_middleware'
require 'csv'

Dotenv.load

class App
  def call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new
    res['Content-Type'] = 'application/json'

    begin
      case req.path
      when '/'
        res['Content-Type'] = 'text/html'
        res.write File.read('views/index.html')
        return res.finish

      # AUTH API
      when '/api/signup'
        if req.post?
          params = JSON.parse(req.body.read)
          user_id = User.create(params['username'], params['email'], params['password'])
          res.status = 201
          res.write({ message: 'User created', user_id: user_id }.to_json)
        end

      when '/api/login'
        if req.post?
          params = JSON.parse(req.body.read)
          user = User.authenticate(params['email'], params['password'])
          if user
            token = JWT.encode({ user_id: user['id'], exp: Time.now.to_i + 3600*24 }, ENV['JWT_SECRET'], 'HS256')
            res.write({ 
              token: token, 
              user: { 
                id: user['id'], 
                username: user['username'],
                fingerprint_enabled: user['fingerprint_enabled'] == 1
              } 
            }.to_json)
          else
            res.status = 401
            res.write({ error: 'Invalid credentials' }.to_json)
          end
        end

      # ACCOUNTS API
      when '/api/accounts'
        user_id = env['current_user_id']
        if req.get?
          res.write Account.all_by_user(user_id).to_json
        elsif req.post?
          params = JSON.parse(req.body.read)
          Account.create(user_id, params['name'], params['type'], params['balance'])
          res.status = 201
          res.write({ message: 'Account created' }.to_json)
        end

      # TRANSACTIONS API
      when '/api/transactions'
        user_id = env['current_user_id']
        if req.get?
          month = req.params['month']
          year = req.params['year']
          res.write Transaction.all_by_user(user_id, month, year).to_json
        elsif req.post?
          params = JSON.parse(req.body.read)
          Transaction.create(user_id, params['account_id'], params['category_id'], params['type'], params['amount'].to_f, params['date'], params['notes'], params['to_account_id'])
          res.status = 201
          res.write({ message: 'Transaction created' }.to_json)
        end
      
      when '/api/transactions/export'
        user_id = env['current_user_id']
        transactions = Transaction.all_by_user(user_id)
        
        csv_data = CSV.generate(col_sep: ',', quote_char: '"') do |csv|
          csv << ["Tanggal", "Tipe", "Kategori", "Dompet", "Nominal", "Catatan"]
          transactions.each do |t|
            csv << [t['date'], t['type'], t['category_name'], t['account_name'], t['amount'], t['notes']]
          end
        end

        res['Content-Type'] = 'text/csv'
        res['Content-Disposition'] = "attachment; filename=\"glowfinance_export_#{Time.now.strftime('%Y%m%d')}.csv\""
        res.write csv_data
        return res.finish

      # CATEGORIES API
      when '/api/categories'
        user_id = env['current_user_id']
        if req.get?
          res.write Category.all_by_user(user_id).to_json
        end

      # BUDGETS API
      when '/api/budgets'
        user_id = env['current_user_id']
        if req.get?
          month = req.params['month'] || Time.now.month
          year = req.params['year'] || Time.now.year
          res.write Budget.all_by_user(user_id, month, year).to_json
        elsif req.post?
          params = JSON.parse(req.body.read)
          Budget.create(user_id, params['category_id'], params['limit_amount'].to_f, params['month'], params['year'])
          res.status = 201
          res.write({ message: 'Budget set' }.to_json)
        end

      # GOALS API
      when '/api/goals'
        user_id = env['current_user_id']
        if req.get?
          res.write Goal.all_by_user(user_id).to_json
        elsif req.post?
          params = JSON.parse(req.body.read)
          Goal.create(user_id, params['name'], params['target_amount'].to_f, params['deadline'])
          res.status = 201
          res.write({ message: 'Goal created' }.to_json)
        end
      
      when '/api/goals/contribute'
        if req.post?
          params = JSON.parse(req.body.read)
          Goal.add_contribution(params['id'], params['amount'].to_f)
          res.write({ message: 'Contribution added' }.to_json)
        end

      when '/api/user/profile'
        user_id = env['current_user_id']
        user = User.find_by_id(user_id)
        # Jangan kirim password_digest
        user.delete('password_digest')
        res.write user.to_json

      when '/api/user/fingerprint'
        user_id = env['current_user_id']
        params = JSON.parse(req.body.read)
        User.update_fingerprint(user_id, params['enabled'], params['credential_id'])
        res.write({ status: 'success' }.to_json)

      else
        res.status = 404
        res.write({ error: 'Not Found' }.to_json)
      end
    rescue => e
      puts "ERROR: #{e.message}"
      puts e.backtrace.join("\n")
      res.status = 500
      res.write({ error: e.message, backtrace: e.backtrace.first(5) }.to_json)
    end

    res.finish
  end
end
