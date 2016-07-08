class Article < ActiveRecord::Base

  belongs_to :category
  has_many :pictures, :dependent => :destroy
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :reads, :as => :readable

  # validate :valid_start_date

  # def valid_date(date)
  #   if date.present?
  #     errors[date] << "is not valid" unless valid_date?(date)
  #   end
  # end

  # def valid_date?(this_date)
  #     begin
  #       Date.parse(this_date)
  #     rescue
  #     else
  #     end
  # end

  # accepts_nested_attributes_for :pictures, :reject_if => lambda { |t| t['picture'].nil? }

  # scope :status, -> (status) { where status: status }
  # scope :location, -> (location_id) { where location_id: location_id }
  # scope :created, -> () { where("created_at >= ?", Time.zone.now.beginning_of_day) }

  def read_count
    reads.size
  end

  def today_count(a='all')
    if a == 'today'
      reads.where("created_at >= ?", Time.zone.now.beginning_of_day).size
    elsif a == 'all'
      reads.size
    end
  end

  def range_count(start_params, end_params)
    start_date = DateTime.new(start_params['date(1i)'].to_i, start_params['date(2i)'].to_i, start_params['date(3i)'].to_i)
    end_date = DateTime.new(end_params['date(1i)'].to_i, end_params['date(2i)'].to_i, end_params['date(3i)'].to_i)
    reads.where("created_at < ? AND created_at > ?", end_date, start_date).size
  rescue ArgumentError
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

  class DateException < StandardError
    def initialize(data)
      @data = data
    end
  end

end
