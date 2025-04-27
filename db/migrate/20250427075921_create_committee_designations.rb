class CreateCommitteeDesignations < ActiveRecord::Migration[5.2]
  def change
    create_table :committee_designations do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
