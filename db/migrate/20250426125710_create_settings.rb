class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.string :logo
      t.text :contact_address
      t.text :aboutus
      t.text :mission
      t.text :vission

      t.timestamps
    end
  end
end
