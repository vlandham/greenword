class AddUrlToSemester < ActiveRecord::Migration
  def self.up
    add_column "semesters", "url", :string
  end

  def self.down
    remove_column "semesters", "url"
  end
end
