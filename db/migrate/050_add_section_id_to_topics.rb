class AddSectionIdToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :section_id, :integer
  end

  def self.down
    remove_column :topics, :section_id
  end
end
