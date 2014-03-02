class RemoveInvolvedColumnFromUsersTable < ActiveRecord::Migration
  def change
  	remove_column :users, :involved
  end
end
