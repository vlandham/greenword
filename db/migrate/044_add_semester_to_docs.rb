class AddSemesterToDocs < ActiveRecord::Migration
  def self.up
    add_column :documents, :semester_id, :integer
    add_column :documents, :user_id, :integer
  end

  def self.down
    remove_column :documents, :semester_id
    remove_column :documents, :user_id
  end
end
