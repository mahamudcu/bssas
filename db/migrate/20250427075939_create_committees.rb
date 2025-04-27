class CreateCommittees < ActiveRecord::Migration[5.2]
  def change
    create_table :committees do |t|
      t.string :title
      t.text :description
      t.integer :duration
      t.date :duration_date
      t.date :stablish_date
      t.date :clossing_date
      t.boolean :active
      t.references :committee_designation, foreign_key: true

      t.timestamps
    end
  end
end
