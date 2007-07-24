class ChangeFreezeToLocked < ActiveRecord::Migration
  def self.up
    rename_column :semesters, :freeze, :locked
  end

  def self.down
    rename_column :semesters, :locked, :freeze
  end
end
