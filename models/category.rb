require_relative 'base_model'

class Category < BaseModel
  def self.all_by_user(user_id)
    query("SELECT * FROM categories WHERE user_id = ? OR user_id IS NULL", [user_id]).to_a
  end

  def self.create(user_id, name, icon, color, type)
    query("INSERT INTO categories (user_id, name, icon, color, type) VALUES (?, ?, ?, ?, ?)", [user_id, name, icon, color, type])
    last_id
  end
end
