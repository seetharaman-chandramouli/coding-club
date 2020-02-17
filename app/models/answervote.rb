class Answervote < ActiveRecord::Base
	belongs_to :answer, counter_cache: :vote_count 
	belongs_to :user 
end