class AddUserInfoToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :batch, :string
    add_column :users, :string, :string
    add_column :users, :student_id, :string
    add_column :users, :section, :string
    add_column :users, :current_company, :string
    add_column :users, :present_address, :string
  end
end
