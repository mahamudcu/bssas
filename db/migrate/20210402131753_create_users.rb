class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :age
      t.string :phone
      t.string :age
      t.string :passing_year
      t.string :address
      t.string :occupation
      t.string :bio
      t.boolean :is_x_student

      t.timestamps
    end
  end
end
