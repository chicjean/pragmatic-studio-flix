class ReviewsController < ApplicationController

	before_action :set_movie
	# Using a before_action is an idiomatic way to remove duplication in a controller, but you can also use before_action to share common functionality across controllers. 

	def index
		@reviews = @movie.reviews
	end

	def new
		#Then use that variable to instantiate a new Review object as a child of the movie and assign it to a @review variable.
		@review = @movie.reviews.new 

		#By looking up the movie in the database, rather than just using the passed in ID, we also verify that the ID corresponds to a valid movie before displaying the form.

		#The review's movie_id will be automatically assigned when initialized this way.
	end

	def create
		@review = @movie.reviews.new(review_params)

		if  @review.save
      #save = true
      redirect_to movie_reviews_path(@movie), notice: "Review successfully created!"
    else
      #save = false
      render :new
    end
	
	end

private

	def review_params
		params.require(:review).permit(:name, :stars, :comment)
	end

	def set_movie
		@movie = Movie.find(params[:movie_id])
	end

end
