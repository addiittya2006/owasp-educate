class Picture < ActiveRecord::Base

  belongs_to :article

  has_attached_file :image,
                    styles: { small: "64x64", med: "100x100", large: "200x200" },
                    :path => ENV["OPENSHIFT_DATA_DIR"]+"public/images/:id/:filename",
                    :url  => "/images/:id/:filename"

  validates_attachment :image, :size => { :in => 0..500.kilobytes }
  validates_attachment :image, :content_type => { :content_type => ["image/jpg", "image/png"] }

end
