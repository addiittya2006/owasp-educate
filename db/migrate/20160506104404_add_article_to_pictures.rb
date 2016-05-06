class AddArticleToPictures < ActiveRecord::Migration
  def change
    add_reference :pictures, :article, index: true
  end
end
