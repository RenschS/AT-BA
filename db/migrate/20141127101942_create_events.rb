class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :startdate
      t.string :enddate
      t.integer :iPhoneUser
      t.integer :iPadUser
      t.integer :androidUser
      t.integer :mwUser
      t.integer :iPhoneSessions
      t.integer :iPadSessions
      t.integer :androidSessions
      t.integer :mwSessions
      t.integer :iPhoneMedianSL
      t.integer :iPadMedianSL
      t.string :androidMedianSL
      t.integer :iPhoneAvgActiveUsers
      t.integer :iPadAvgActiveUsers
      t.integer :androidAvgActiveUsers
      t.references :analytic, index: true

      t.timestamps
    end
  end
end
