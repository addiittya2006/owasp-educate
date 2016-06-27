class Article < ActiveRecord::Base

  belongs_to :category
  has_many :pictures, :dependent => :destroy
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :reads, :as => :readable

  # accepts_nested_attributes_for :pictures, :reject_if => lambda { |t| t['picture'].nil? }

  def read_count
    reads.size
  end

  def unique_read_count
    reads.group(:ip_address).length
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).articles
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").joins(:taggings).group("taggings.tag_id")
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  def tag_name
    tag.name if tag
  end

  def tag_name=(name)
    self.tag = Tag.find_or_create_by_name(name) unless name.blank?
  end

end
