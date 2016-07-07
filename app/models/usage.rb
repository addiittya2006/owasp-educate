class Usage < ActiveRecord::Base

  belongs_to :usable, polymorphic: true

end
