class AddUsingOpenidToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :using_openid, :boolean
  end

  def self.down
    remove_column :users, :using_openid
  end
end
