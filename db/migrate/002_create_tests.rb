class CreateTests < ActiveRecord::Migration
  def self.up
    create_table :tests do |t|
      t.column :semester_id, :integer
      t.column :language, :integer
      t.column :name, :string
    end
  end

  def self.down
    drop_table :tests
  end
end
