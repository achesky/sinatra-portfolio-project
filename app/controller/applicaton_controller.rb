require './config/environment.rb'

class ApplicationController < Sinatra::Base

    configure do
      set :public_folder, 'public'
      set :views, 'app/views'
      enable :sessions
      set :session_secret, "bigbang"
    end


    get '/' do
      erb :index
    end

    post '/signup' do
      @student = Student.create(params)
      @session = session
      @session[:id] = @student.id
      if is_logged_in? && !params[:username].empty? && !params[:email].empty? && !params[:password].empty?
        redirect '/courses'
      else
        redirect '/signup'
      end
    end

    get '/signup' do
      @session = session
      if is_logged_in?
        redirect '/courses'
      else
        erb :'/students/create_student'
      end
    end

    get '/login' do
      if is_logged_in?
        redirect '/courses'
      else
        erb :'/students/login'
      end
    end

    post '/login' do
      @student = Student.find_by(username: params[:username], password: params[:password])
      @session = session
      @session[:id] = @student.id
      redirect '/courses'
    end

    get '/logout' do
      session.delete(:id)
      redirect '/login'
    end

    get '/courses' do
      if is_logged_in?
        @student = Student.find_by_id(session[:id])
        erb :'/courses/courses'
      else
        redirect '/login'
      end
    end

    get '/users/:slug' do
      @student = Student.find_by_slug(params[:slug])
      erb :'/courses/show_courses/'
    end

    get '/courses/new' do
      if is_logged_in?
        erb :'/courses/create_course'
      else
        redirect '/login'
      end
    end

    post '/courses' do
      if params[:content] == ""
        redirect '/courses/new'
      else
        @student = Student.find_by_id(session[:id])
        new_course = Course.create(content: params[:review], user_id: session[:id])
        redirect '/courses'
      end
    end

    patch '/courses/:id' do
      @new_course = Course.find_by_id(params[:id])
      @new_course.content = params[:review]
      @new_course.save
      redirect '/courses/#{@new_course.id}/edit'
    end

    get '/courses/:id' do
      if is_logged_in?
        @course = Course.find_by_id(params[:id])
        erb :'/courses/edit_course'
      else
        redirect '/login'
      end
    end

    get '/courses/:id/edit' do
      if is_logged_in?
        @course = Course.find_by_id(param[:id])
        erb :'courses/edit_course'
      else
        redirect '/login'
      end
    end

    delete '/courses/:id' do
      @course = Course.find_by_id(params[:id])
      if @course.user_id == session[:id]
        @tweet.destroy
      end
      redirect '/courses'
    end

    helpers do
      def is_logged_in?
        @session = session
        @session.has_key?(:id) ? true : false
      end

      def current_user
        @session = session
        Student.find_by_id(@session[:id])
      end
    end
end
