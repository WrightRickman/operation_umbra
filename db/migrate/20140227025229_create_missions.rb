class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.string :description, :limit => 160
      t.integer :level
      t.boolean :assassination, :default => false

      t.timestamps
    end
  end
end
