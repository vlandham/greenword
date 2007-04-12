class AddModTestToTestSetId < ActiveRecord::Migration
  def self.up
    remove_column "scenarios", "test_id"
    remove_column "words", "test_id"
    remove_column "completions", "test_id"
    add_column "scenarios", "test_set_id", :integer
    add_column "words", "test_set_id", :integer
    add_column "completions", "test_set_id", :integer
  end

  def self.down
    remove_column "scenarios", "test_set_id"
    remove_column "words", "test_set_id"
    remove_column "completions", "test_set_id"
    add_column "scenarios", "test_id", :integer
    add_column "words", "test_id", :integer
    add_column "completions", "test_id", :integer
  end
end
