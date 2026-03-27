require_relative 'base_model'

class Budget < BaseModel
  def self.all_by_user(user_id, month, year)
    query("SELECT b.*, c.name as category_name, 
           (SELECT IFNULL(SUM(amount), 0) FROM transactions WHERE category_id = b.category_id AND user_id = b.user_id AND type = 'expense' AND MONTH(date) = ? AND YEAR(date) = ?) as spent 
           FROM budgets b 
           JOIN categories c ON b.category_id = c.id 
           WHERE b.user_id = ? AND b.`month` = ? AND b.`year` = ?", [month.to_i, year.to_i, user_id.to_i, month.to_i, year.to_i]).to_a
  end

  def self.create(user_id, category_id, limit_amount, month, year)
    query("INSERT INTO budgets (user_id, category_id, limit_amount, month, year) VALUES (?, ?, ?, ?, ?)", [user_id, category_id, limit_amount, month, year])
    last_id
  end
end
