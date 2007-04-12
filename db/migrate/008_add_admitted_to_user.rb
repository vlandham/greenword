class AddAdmittedToUser < ActiveRecord::Migration
  def self.up
    add_column "users", "admitted", :boolean, :default => false
  end

  def self.down
    remove_column "users", "admitted"
  end
end
