class AddDetailsToAnalytics < ActiveRecord::Migration
  def change
    add_column :analytics, :android_key, :text
    add_column :analytics, :iphone_key, :text
    add_column :analytics, :ipad_key, :text
  end
end
