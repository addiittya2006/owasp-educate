class Article < ActiveRecord::Base

  belongs_to :category
  has_many :pictures, :dependent => :destroy
  # has_many :taggings
  # has_many :tags, through: :taggings
  acts_as_taggable

  # accepts_nested_attributes_for :pictures, :reject_if => lambda { |t| t['picture'].nil? }

end
