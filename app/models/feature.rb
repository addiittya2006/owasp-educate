class Feature < ActiveRecord::Base

  has_many :usages, :as => :usable

  def range_count(start_params, end_params)
    start_date = DateTime.new(start_params['date(1i)'].to_i, start_params['date(2i)'].to_i, start_params['date(3i)'].to_i)
    end_date = DateTime.new(end_params['date(1i)'].to_i, end_params['date(2i)'].to_i, end_params['date(3i)'].to_i)
    usages.where("created_at < ? AND created_at > ?", end_date, start_date).size
  rescue ArgumentError
    usages.count
  end

end
