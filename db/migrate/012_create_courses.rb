class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.column :section_id, :integer
      t.column :name, :string
      t.column :number, :string
    end
  end

  def self.down
    drop_table :courses
  end
end
