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
    meal = Meal.create(:name => params["name"], :description => params["description"], :calories => params["calories"], :date => params["date"], :prepared_by => params["prepared_by"], :rating =>["rating"], :user_id => user.id)
    redirect '/meals'
  end

  get "/meals/:id" do
    @meal = Meal.find(params[:id])
    @user = Helpers.current_user(session)
    erb :"/meals/show"
  end

  get "/meals/:id/edit" do
    @meal = Meal.find(params[:id])
    @user = Helpers.current_user(session)
    erb :"/meals/edit"
  end

  patch "/meals/:id" do
    @meal = Meal.find(params[:id])
    @meal.update(:name => params["name"], :description => params["description"], :calories => params["calories"], :date => params["date"], :prepared_by => params["prepared_by"], :rating => params["rating"])
    @meal.save
    redirect "/meals/#{@meal.id}"
  end

  post "/meals/:id/delete" do
    @meal = Meal.find(params[:id])
    @meal.delete
    redirect "/meals"
  end


end
