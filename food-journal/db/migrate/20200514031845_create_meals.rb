class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.string :type
      t.string :description
      t.integer :calories
      t.integer :user_id
    end
  end
end
