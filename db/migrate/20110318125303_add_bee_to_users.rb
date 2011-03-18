class AddBeeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :avatar_image_url, :string
  end

  def self.down
    remove_column :users, :avatar_image_url
  end
end
