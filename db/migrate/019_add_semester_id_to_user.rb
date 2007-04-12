class AddSemesterIdToUser < ActiveRecord::Migration
  def self.up
    add_column "users", "semester_id", :integer
  end

  def self.down
    remove_column "users", "semester_id"
  end
end
