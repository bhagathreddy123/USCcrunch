class AddColumnToUser < ActiveRecord::Migration
  def change
       add_column :users, :exam_name, :string
  end
end
