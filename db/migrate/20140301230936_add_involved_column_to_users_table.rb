class AddInvolvedColumnToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :involved, :boolean, default: false
  end
end
