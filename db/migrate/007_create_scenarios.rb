class CreateScenarios < ActiveRecord::Migration
  def self.up
    create_table :scenarios do |t|
      t.column :value, :text
      t.column :test_id, :integer
      t.column :show,   :boolean
    end
  end

  def self.down
    drop_table :scenarios
  end
end
