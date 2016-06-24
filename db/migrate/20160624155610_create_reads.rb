class CreateReads < ActiveRecord::Migration
  def change
    create_table :reads do |t|
      t.string :user_id
      t.string :ip_address

      t.belongs_to :readable, polymorphic: true

      t.timestamps
    end
    add_index :reads, :readable_id
  end
end
