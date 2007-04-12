class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.column :semester_id, :integer
      t.column :name, :string
    end
  end

  def self.down
    drop_table :sections
  end
end
