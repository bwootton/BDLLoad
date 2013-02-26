class CreateInstructions < ActiveRecord::Migration
  def change
    create_table :instructions do |t|
      t.integer :bdl_file_id
      t.string :uname
      t.string :i_type
      t.binary :data
      t.timestamps
    end

    create_table :name_values do |nv|
      nv.integer :instruction_id
      nv.string :name
      nv.binary :value
    end

    create_table :references do |r|
      r.integer :instruction_id
      r.integer :child_id
    end
  end
end
