class Subsection < ApplicationRecord

  	belongs_to :section
	has_many :topics
	
	after_save :broadcast_update

end
