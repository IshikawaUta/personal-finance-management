require_relative 'base_model'

class Account < BaseModel
  def self.create(user_id, name, type, balance, currency = 'IDR')
    query("INSERT INTO accounts (user_id, name, type, balance, currency) VALUES (?, ?, ?, ?, ?)", [user_id, name, type, balance, currency])
    last_id
  end

  def self.all_by_user(user_id)
    query("SELECT * FROM accounts WHERE user_id = ?", [user_id]).to_a
  end

  def self.update_balance(id, amount)
    query("UPDATE accounts SET balance = balance + ? WHERE id = ?", [amount, id])
  end
end
