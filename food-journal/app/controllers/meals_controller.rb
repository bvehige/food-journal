require './config/environment'

class MealsController < ApplicationController

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/meals" do
    if !Helpers.is_logged_in?(session)
        redirect '/login'
    end
    @meals = Meal.all
    @user = Helpers.current_user(session)
    erb :"/meals/meals"
  end

  get "/meals/new" do
    
    erb :"/meals/new"
  end

  post "/meals" do
    user = Helpers.current_user(session)
    meal = Meal.create(:name => params["name"], :description => params["description"], :calories => params["calories"], :date => params["date"], :user_id => user.id)
    redirect '/meals'

  end

end
