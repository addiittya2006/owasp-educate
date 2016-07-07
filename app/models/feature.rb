class Feature < ActiveRecord::Base

  has_many :usages, :as => :usable

end
