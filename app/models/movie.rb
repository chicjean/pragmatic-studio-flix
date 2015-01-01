class Movie < ActiveRecord::Base

  has_many :reviews, dependent: :destroy

  #Paperclip validation that tells the model that it can have an attachment called image with metadata stored in database fields that have an image_ prefix
  has_attached_file :image, styles: {
    small: "90x133>",
    thumb: "50x50>"
  }

  #Values for the fields title, released_on, and duration must be present.
  validates :title, :released_on, :duration, presence: true

  #The description field must have a minimum of 25 characters.
  validates :description, length: { minimum: 25 }

  #The total_gross field must be a number greater than or equal to 0.
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }

  #The image_file_name field must be formatted so that the file name has at least one word character and a "gif", "jpg", or "png" extension. This uses a regular expression. 
  # validates :image_file_name, allow_blank: true, format: {
  #   with:    /\w+.(gif|jpg|png)\z/i,
  #   message: "must reference a GIF, JPG, or PNG image"
  # }

  #Paperclip validation. This ensures that the actual content type of the image file, regardless of the file name extension, is a JPEG or PNG file. 
   validates_attachment :image, 
    :content_type => { :content_type => ['image/jpeg', 'image/png'] },
    :size => { :less_than => 1.megabyte }

  #Finally, the rating field must have one of the following values: "G", "PG", "PG-13", "R", or "NC-17". RATINGS is a Ruby constant.
  RATINGS = %w(G PG PG-13 R NC-17)
  validates :rating, inclusion: { in: RATINGS }

  def self.released
    where("released_on <= ?", Time.now).order("released_on desc")
  end
  
  def self.hits
    where('total_gross >= 300000000').order('total_gross desc')
  end
  
  def self.flops
    where('total_gross < 10000000').order('total_gross asc')
  end
  
  def self.recently_added
    order('created_at desc').limit(3)
  end
  
  def flop?
    total_gross.blank? || total_gross < 50000000
  end

  def average_stars
    reviews.average(:stars)
    #Because you're inside of an instance method you don't need to use the movie object. The current object (self) will already be set to a movie object and it becomes the implicit receiver of the call to reviews.
  end

end


# Cult Movies
# We all know of a movie that didn't necessarily gross a ton at the box office, but the few people who did watch the movie really loved it! We call those movies cult classics. And to a specific group of fans they are blockbusters.

# Change the definition of flop movies so that cult classics aren't included. For example, if a movie has more than 50 reviews and the average review is 4 stars or better, then the movie shouldn't be a flop regardless of the total gross.

# Here's a hint: Because the logic for determining whether a movie is a flop is tucked inside the Movie model, you can make this change in one place. When you can do that, you know you're on the right design path!


# Delete Reviews
# Add functionality to delete reviews. It ends up being very similiar to the flow for deleting movies, but you'll need to use a nested route helper method to generate the "Delete" link. Then in the destroy action, you'll need to use the reviews association to find the existing review that's associated with the movie specified in the URL.


# Edit Reviews
# To take things up a notch, add functionality to edit existing reviews. Again, it's similar to editing movies, but involves using the nested routes. To avoid duplication, use a form partial to reuse the existing form for creating reviews.
