class AddMissingFields < ActiveRecord::Migration
  def up
    add_column :faqs, :class_id, :integer
    add_column :readings, :class_id, :integer
    add_column :importent_links, :class_id, :integer
  end

  def down
    remove_column :faqs, :class_id
    remove_column :readings, :class_id
    remove_column :importent_links, :class_id
  end
end
