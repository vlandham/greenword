class AddCreatedOnToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :created_on, :datetime
  end

  def self.down
    remove_column :links, :created_on
  end
end
