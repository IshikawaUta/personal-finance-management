require_relative 'base_model'
require_relative 'account'

class Transaction < BaseModel
  def self.create(user_id, account_id, category_id, type, amount, date, notes, to_account_id = nil)
    # Start transaction (MySQL)
    client.query("START TRANSACTION")
    begin
      query("INSERT INTO transactions (user_id, account_id, category_id, type, amount, date, notes, to_account_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", 
            [user_id, account_id, category_id, type, amount, date, notes, to_account_id])
      
      case type
      when 'income'
        Account.update_balance(account_id, amount)
      when 'expense'
        Account.update_balance(account_id, -amount)
      when 'transfer'
        Account.update_balance(account_id, -amount)
        Account.update_balance(to_account_id, amount)
      end
      
      client.query("COMMIT")
      last_id
    rescue => e
      client.query("ROLLBACK")
      raise e
    end
  end

  def self.all_by_user(user_id, month = nil, year = nil)
    sql = "SELECT t.*, c.name as category_name, a.name as account_name FROM transactions t 
           LEFT JOIN categories c ON t.category_id = c.id 
           JOIN accounts a ON t.account_id = a.id 
           WHERE t.user_id = ?"
    params = [user_id]

    if month && month != ""
      sql += " AND MONTH(t.date) = ?"
      params << month.to_i
    end

    if year && year != ""
      sql += " AND YEAR(t.date) = ?"
      params << year.to_i
    end

    sql += " ORDER BY t.date DESC, t.id DESC"
    query(sql, params).to_a
  end
end
