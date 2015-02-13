class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :commenter
      t.text :body

      # this line adds an integer column called `tool_id`.
      t.references :tool, index: true

      t.timestamps
    end
  end
end
