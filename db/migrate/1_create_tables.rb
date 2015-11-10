class CreateTables < ActiveRecord::Migration

# bundle exec rake db:migrate
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.timestamps null: false
    end

    create_table :movies do |t|
      t.string :title
      t.string :genre
      t.string :description
      t.string :director
      t.string :image_art
      t.timestamps null: false
    end

    create_table :reviews do |t|
      t.string :score
      t.string :comments
      t.references :user
      t.references :movie
      t.timestamps null: false
    end
  end

end


#get_movies_and_reviews
  #movies = Movies.all
  #movies.each do |movie|
    #movies.reviews
  #end
  #return movie_data
#end


