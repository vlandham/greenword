class AddEnrollableToSemester < ActiveRecord::Migration
  def self.up
    add_column :semesters, :enrollable, :boolean
  end

  def self.down
    remove_column :semesters, :enrollable
  end
end
