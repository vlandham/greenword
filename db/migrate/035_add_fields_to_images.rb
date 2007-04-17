class AddFieldsToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :created_at, :datetime
    add_column :images, :user_id, :integer
  end

  def self.down
  end
end
