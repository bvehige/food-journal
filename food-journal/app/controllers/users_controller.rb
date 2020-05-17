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
    params.each do |label, input|
        if input.empty?
        flash[:sign_up_alert] = "All inputs required. Please fill out the #{label} field."
        redirect '/signup'
        end
    end
    @user = User.create(:username => params["username"], :email => params["email"], :password => params["password"])
    session[:user_id] = @user.id
    flash[:sign_up_message] = "Successfully Signed Up."
    redirect "/meals"
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
        flash[:login_error] = "Invalid Login. Please Try Again" 
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