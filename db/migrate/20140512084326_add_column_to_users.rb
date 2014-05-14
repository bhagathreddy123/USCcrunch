class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contact_no, :string
    add_column :users, :guardian_no, :string
  end
end

