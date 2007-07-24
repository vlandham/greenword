class AddPositionToScenarios < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :position, :integer
  end

  def self.down
    remove_column :scenarios, :position
  end
end
