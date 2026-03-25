require 'mysql2'
require 'dotenv'

Dotenv.load

class BaseModel
  def self.client
    Thread.current[:db_client] ||= Mysql2::Client.new(
      host: ENV['DB_HOST'],
      username: ENV['DB_USER'],
      password: ENV['DB_PASS'],
      database: ENV['DB_NAME'],
      reconnect: true
    )
  end

  def self.query(sql, params = [])
    # Prepared statements are thread-safe per connection
    # and we now have one connection per thread.
    statement = client.prepare(sql)
    statement.execute(*params)
  end

  def self.last_id
    client.last_id
  end
end
