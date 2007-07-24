class AddSubtitleToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :subtitle, :text
  end

  def self.down
    remove_column :topics, :subtitle
  end
end
