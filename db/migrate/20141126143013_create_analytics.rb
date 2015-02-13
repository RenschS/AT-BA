class CreateAnalytics < ActiveRecord::Migration
  def change
    create_table :analytics do |t|
      t.string :title
      t.text :date1
      t.text :date2
      t.text :android_key
      t.text :iphone_key
      t.text :ipad_key

      t.timestamps
    end
  end
end
