class ModifyEnrollable < ActiveRecord::Migration
  def self.up
    remove_column :semesters, :enrollable
    add_column :semesters, :enrollable, :boolean, :default => false
  end

  def self.down
    add_column :semesters, :enrollable, :boolean
    remove_column :semesters, :enrollable
  end
end
