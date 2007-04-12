class ModClassesToCoursesForUsers < ActiveRecord::Migration
  def self.up
    remove_column "users", "class_id"
    add_column "users", "course_id", :integer
  end

  def self.down
    remove_column "users", "course_id"
    add_column "users", "class_id", :integer
  end
end
