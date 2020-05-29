require './config/environment'
require 'sinatra/base'
require 'rack-flash'

class MealsController < ApplicationController
   

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/meals" do
    if !logged_in?
        redirect '/login'
    end
    @meals = Meal.all
    @user = User.find(session[:user_id])
    erb :"/meals/meals"
  end

  get "/meals/new" do
    if !logged_in?
        redirect '/login'
    end
    erb :"/meals/new"
  end

  post "/meals" do
    user = User.find(session[:user_id])
    if params["name"].empty? || params["description"].empty? || params["calories"].empty? || params["date"].empty? || params["prepared_by"].empty? || params["rating"].empty?
      flash[:content_missing_error] = "Please fill out all content items."
      redirect to '/meals/new'
    end
    meal = Meal.create(:name => params["name"], :description => params["description"], :calories => params["calories"], :date => params["date"], :prepared_by => params["prepared_by"], :rating =>params["rating"], :user_id => user.id)
    flash[:created_meal_message] = "Successfully Added a New Meal."
    redirect '/meals'
  end

  get "/meals/:id" do
    if params[:id].to_i > Meal.last.id
      flash[:meal_not_found] = "Meal Not Found"
      redirect to '/meals'
    end

    @meal = Meal.find(params[:id])
    
    if session[:user_id] != @meal.user_id
      flash[:wrong_user_view_error] = "You can only view your own meals."
      redirect to "/meals"
    end
    @user = User.find(session[:user_id])
    erb :"/meals/show"
  end

  get "/meals/:id/edit" do
    if !logged_in?
      redirect to "/login"
    end
    @meal = Meal.find(params[:id])
    if session[:user_id] != @meal.user_id
      flash[:wrong_user_error] = "You can only update your own meals."
      redirect to "/meals"
    end
    @user = User.find(session[:user_id])
    erb :"/meals/edit"
  end

  patch "/meals/:id" do
    @meal = Meal.find(params[:id])
      if params["name"].empty? || params["description"].empty? || params["calories"].empty? || params["date"].empty? || params["prepared_by"].empty? || params["rating"].empty?
        flash[:content_missing_error] = "Please fill out all content items."
        redirect to "/meals/#{params[:id]}/edit"
      end
    @meal.update(:name => params["name"], :description => params["description"], :calories => params["calories"], :date => params["date"], :prepared_by => params["prepared_by"], :rating => params["rating"])
    @meal.save
    flash[:edited_message] = "Successfully Edited Meal."
    redirect "/meals/#{@meal.id}"
  end

  post "/meals/:id/delete" do
    @meal = Meal.find(params[:id])
    if session[:user_id] != @meal.user_id
      flash[:wrong_user_error] = "You can only update your own meals."
      redirect to "/meals"
    end
    @meal.delete
    flash[:deleted_message] = "Successfully Deleted Meal"
    redirect "/meals"
  end

end
