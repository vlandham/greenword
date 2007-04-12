class AddLanguageToUsers < ActiveRecord::Migration
  def self.up
    add_column "users", "language", :string, :default => "en"
  end

  def self.down
     add_column "users", "language"
  end
end
