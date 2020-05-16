require './config/environment'
require 'sinatra/base'
require 'rack-flash'

class UsersController < ApplicationController
  
  get "/signup" do
    if !session[:user_id]
    erb :"/users/new"
    else
    redirect '/meals'
    end
  end

  post "/signup" do
    @user = User.new(:username => params["username"], :email => params["email"], :password => params["password"])
    if !@user.save
        @errors = @user.errors.full_messages
    # if params[:username].empty? || params[:email].empty? || params[:password].empty?
        # flash[:sign_up_alert] = "All inputs required. Please don't leave any input blank."
        redirect '/signup'
    else
    session[:user_id] = user.id
    flash[:sign_up_message] = "Successfully signed up."
    redirect "/meals"
    end
  end

  get "/login" do
    erb :"users/login"
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect "/meals"
    else
        flash[:login_error] = "Invalid login. Please try again" 
        erb :"/users/login"
    end

  end

  get "/logout" do
    if Helpers.is_logged_in?(session)
        session.clear
        redirect "/login"
    else
        redirect "/"
    end

  end

 
end