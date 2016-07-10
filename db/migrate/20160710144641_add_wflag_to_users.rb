class AddWflagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wflag, :boolean
  end
end
