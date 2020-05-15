class RenameColumn < ActiveRecord::Migration
  def change
    rename_column :meals, :type, :name
  end
end
