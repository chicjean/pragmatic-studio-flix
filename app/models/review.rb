class Review < ActiveRecord::Base
  belongs_to :movie

  #A value for the name field must be present.
  validates :name, presence: true

  #The comment field must have a minimum of 4 characters.
  validates :comment, length: { minimum: 4 }

  #The stars field should have a value between 1 and 5. Similar to how we used a RATINGS constant for the movie rating validation, use a STARS constant for review star validation. Override the default error message for this validation with the custom message "must be between 1 and 5".
  STARS = [1, 2, 3, 4, 5]

	validates :stars, inclusion: { 
  	in: STARS,
  	message: "must be between 1 and 5"
	}
	
end
