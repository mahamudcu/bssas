class CreateCommitteeMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :committee_members do |t|
      t.references :user, foreign_key: true
      t.references :committee, foreign_key: true
      t.references :committee_designation, foreign_key: true
      t.integer :added_by_id
      t.integer :remove_by_id
      t.integer :approve_by_id
      t.boolean :is_approved
      t.text :description

      t.timestamps
    end
  end
end
