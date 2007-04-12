class CreateWords < ActiveRecord::Migration
  def self.up
    create_table :words do |t|
      t.column :test_id, :integer
      t.column :value, :string
      t.column :show, :boolean
      t.column :order, :integer
    end
  end

  def self.down
    drop_table :words
  end
end
