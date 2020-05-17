require './config/environment'
require 'sinatra/base'
require 'rack-flash'

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
    if !Helpers.is_logged_in?(session)
        redirect '/login'
    end
    erb :"/meals/new"
  end

  post "/meals" do
    user = Helpers.current_user(session)
    meal = Meal.create(:name => params["name"], :description => params["description"], :calories => params["calories"], :date => params["date"], :prepared_by => params["prepared_by"], :rating =>params["rating"], :user_id => user.id)
    flash[:created_meal_message] = "Successfully Added a New Meal."
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
    flash[:edited_message] = "Successfully Edited Meal."
    redirect "/meals/#{@meal.id}"
  end

  post "/meals/:id/delete" do
    @meal = Meal.find(params[:id])
    @meal.delete
    flash[:deleted_message] = "Successfully Deleted Meal"
    redirect "/meals"
  end


end
