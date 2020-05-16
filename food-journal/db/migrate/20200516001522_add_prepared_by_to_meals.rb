class AddPreparedByToMeals < ActiveRecord::Migration
  def change
      add_column :meals, :prepared_by, :string
  end
end
