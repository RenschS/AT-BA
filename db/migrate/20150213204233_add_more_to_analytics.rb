class AddMoreToAnalytics < ActiveRecord::Migration
  def change
    add_column :analytics, :iPhoneUser, :integer
    add_column :analytics, :iPadUser, :integer
    add_column :analytics, :androidUser, :integer
    add_column :analytics, :mwUser, :integer
    add_column :analytics, :iPhoneSessions, :integer
    add_column :analytics, :iPadSessions, :integer
    add_column :analytics, :androidSessions, :integer
    add_column :analytics, :mwSessions, :integer
    add_column :analytics, :iPhoneMedianSL, :integer
    add_column :analytics, :iPadMedianSL, :integer
    add_column :analytics, :androidMedianSL, :integer
    add_column :analytics, :iPhoneAvgActiveUsers, :integer
    add_column :analytics, :iPadAvgActiveUsers, :integer
    add_column :analytics, :androidAvgActiveUsers, :integer


  end
end



