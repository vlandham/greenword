class ChangeLanguageTypeTestsets < ActiveRecord::Migration
  def self.up
    remove_column "test_sets", "language"
    add_column "test_sets", "language", :string
  end

  def self.down
    remove_column "test_sets", "language"
    add_column "test_sets", "language", :integer
  end
end
