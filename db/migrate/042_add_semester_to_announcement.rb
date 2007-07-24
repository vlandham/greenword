class AddSemesterToAnnouncement < ActiveRecord::Migration
  def self.up
    add_column :announcements, :semester_id, :integer
    add_column :announcements, :user_id, :integer
  end

  def self.down
    remove_column :announcements, :semester_id
    remove_column :announcements, :user_id
  end
end
