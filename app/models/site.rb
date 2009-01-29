class Site < ActiveRecord::Base
  has_many :topics, :as => :forum
end
