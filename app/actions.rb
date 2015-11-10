helpers do
   def logged_in? 
    session[:user_id]
   end
    
    def current_user
        if logged_in?
            return User.find(session[:user_id])
        end
    end
end

# CSS stuff

#  get '/application.css' do
#  scss :style
#  end

# Homepage (Root path)
get '/index' do
  erb :index
end

# Login
get '/login' do
    erb :login
end

# Signup
get '/signup' do
    erb :signup
end

#Logout
get '/logout' do
    session.clear
    erb :logout
end

#Profile
get '/profile' do
    erb :profile
end

# Profile Edit
get '/profile/:id/edit' do
    @user = User.find(params[:id])
    erb :edit_profile
end

# Profile id generator
get 'profile/:id' do
    @user = User.find(params[:id])
end

# Movie id. generator
get '/movies/:id' do
    @movie = Movie.find(params[:id])
    erb :movie
end

# New Reviews
get '/movies/:movie_id/reviews/new' do
    @movie = Movie.find(params[:movie_id])
    if logged_in?
        erb :new_review
    end
    
end

# New Movies
get '/new_movies' do
    erb :new_movies
end
    
# Movie List
get '/movies' do
    @movies = Movie.where("title like ?", "%#{params[:q]}%")
    erb :movies
end

# Movie Edit
get '/movies/:id/edit' do
   @movie = Movie.find(params[:id]) 
   erb :edit_movie
end

# Login post
post '/login' do
    puts params.inspect
    puts User.first.inspect
    
    # Find user from database
    user = User.find_by(email: params[:email])
  

    # Did we find a user?
    # If yes, do the passwords match?
    
    if user && user.password == params[:password]
    # If a user was found and passwords match...
        # Log user in
        session[:user_id] = user.id
        # Send user to home page
    
    redirect "/new_movies"
    # Else
        # Render erb :login
    else 
        @error = "Oops, it appears you are an idiot!  Try again"
        erb :login
    end
end

# Signup post
post '/signup' do
    # Grab information from user (params)
    # Create new user in database
    new_user = User.create({
        email: params[:email],
        password: params[:password],
        username: params[:username]
    })
    # Log new user in
    
   session[:user_id] = new_user.id
    # Send user to home page
    
    redirect "/index"
end
#add movie

post '/new_movies' do
    #grab information from user (params)
    #create new movie in database
    new_movie = Movie.create({
        title: params[:title],
        genre: params[:genre],
        description: params[:description],
        director: params[:director]
       # image_art: params[:image_art]
    })
    
    redirect "/movies/#{new_movie.id}"
    
end

post '/movies/:movie_id/reviews/create' do
    # find movie to review
    @movie = Movie.find(params[:movie_id])
    # receive user data/input
       # create new review in database
    @movie.reviews.create({
        user_id: current_user.id,
        score: params[:score],
        comments: params[:comments]
    })
    
    redirect "/movies/#{@movie.id}"
    # send user back to movie page
end

post '/movies/:id/update' do
    @movie = Movie.find(params[:id])
    @movie.update({
        title: params[:title],
        genre: params[:genre],
        description: params[:description],
        director: params[:director]
    })
    # update details in database
    redirect "/movies/#{@movie.id}"
end

post '/profile/:user_id/edit_profile' do
    # find user to edit
    @user.update({
        username: params[:username],
        email: params[:email],
        password: params[:password]
    })
    
    redirect "/profile/#{@user.id}"
end

