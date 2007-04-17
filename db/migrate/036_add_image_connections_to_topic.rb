class AddImageConnectionsToTopic < ActiveRecord::Migration
  def self.up
    add_column :images, :topic_id, :integer
  end

  def self.down
    remove_column :images, :topic_id
  end
end
