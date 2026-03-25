require_relative 'base_model'

class Goal < BaseModel
  def self.all_by_user(user_id)
    query("SELECT * FROM goals WHERE user_id = ? ORDER BY status ASC, created_at DESC", [user_id]).to_a
  end

  def self.create(user_id, name, target_amount, deadline = nil)
    query("INSERT INTO goals (user_id, name, target_amount, deadline) VALUES (?, ?, ?, ?)", [user_id, name, target_amount, deadline])
    last_id
  end

  def self.add_contribution(id, amount)
    query("UPDATE goals SET current_amount = current_amount + ? WHERE id = ?", [amount, id])
    # Check if goal achieved
    query("UPDATE goals SET status = 'achieved' WHERE id = ? AND current_amount >= target_amount", [id])
  end
end
