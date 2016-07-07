class CreateUsages < ActiveRecord::Migration
  def change
    create_table :usages do |t|
      t.string :ip_address

      t.belongs_to :usable, polymorphic: true

      t.timestamps
    end
    add_index :usages, :usable_id
  end
end
