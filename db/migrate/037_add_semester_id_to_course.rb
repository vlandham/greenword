class AddSemesterIdToCourse < ActiveRecord::Migration
  def self.up
    add_column :courses, :semester_id, :integer
  end

  def self.down
    remove_column :courses, :semester_id
  end
end
