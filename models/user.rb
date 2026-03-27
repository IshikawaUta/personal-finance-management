require 'bcrypt'
require_relative 'base_model'

class User < BaseModel
  def self.create(username, email, password)
    password_digest = BCrypt::Password.create(password)
    query("INSERT INTO users (username, email, password_digest) VALUES (?, ?, ?)", [username, email, password_digest])
    last_id
  end

  def self.find_by_email(email)
    query("SELECT * FROM users WHERE email = ?", [email]).first
  end

  def self.find_by_id(id)
    query("SELECT * FROM users WHERE id = ?", [id]).first
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    return nil unless user
    BCrypt::Password.new(user['password_digest']) == password ? user : nil
  end

  def self.update_fingerprint(user_id, enabled, credential_id = nil)
    query("UPDATE users SET fingerprint_enabled = ?, public_key_credential_id = ? WHERE id = ?", [enabled, credential_id, user_id])
  end

  def self.find_by_credential_id(credential_id)
    query("SELECT * FROM users WHERE public_key_credential_id = ?", [credential_id]).first
  end
end
