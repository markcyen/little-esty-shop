class AddColumnToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :status, :integer, :default => "disable"
  end
end
