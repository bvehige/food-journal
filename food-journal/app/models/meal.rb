class Meal < ActiveRecord::Base
    belongs_to :user
    validates :name, :description, :calories, :date, :prepared_by, :rating, presence: true
end

