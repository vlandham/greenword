class DropTestsTable < ActiveRecord::Migration
  def self.up
    drop_table :tests
  end

  def self.down
     create_table :tests do |t|
        t.column :semester_id, :integer
        t.column :language, :integer
        t.column :name, :string
      end
  end
end
