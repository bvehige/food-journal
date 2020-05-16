class AddingRatingToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :rating, :string
  end
end
