class CreateSemesters < ActiveRecord::Migration
  def self.up
    create_table :semesters do |t|
      t.column :name, :string
      t.column :created_on, :date
      t.column :freeze, :boolean
    end
  end

  def self.down
    drop_table :semesters
  end
end
