require_relative 'base_model'

class Budget < BaseModel
  def self.all_by_user(user_id, month, year)
    query("SELECT b.*, c.name as category_name, 
           (SELECT SUM(amount) FROM transactions WHERE category_id = b.category_id AND MONTH(date) = ? AND YEAR(date) = ?) as spent 
           FROM budgets b 
           JOIN categories c ON b.category_id = c.id 
           WHERE b.user_id = ? AND b.month = ? AND b.year = ?", [month, year, user_id, month, year]).to_a
  end

  def self.create(user_id, category_id, limit_amount, month, year)
    query("INSERT INTO budgets (user_id, category_id, limit_amount, month, year) VALUES (?, ?, ?, ?, ?)", [user_id, category_id, limit_amount, month, year])
    last_id
  end
end
