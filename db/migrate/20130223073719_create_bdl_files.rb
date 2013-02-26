class CreateBdlFiles < ActiveRecord::Migration
  def change
    create_table :bdl_files do |t|
      t.string :filename
      t.binary :data
      t.timestamps
    end
  end
end
