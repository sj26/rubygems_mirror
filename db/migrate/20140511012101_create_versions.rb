class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.references :project, index: true
      t.string :number
      t.string :platform
      t.text :authors
      t.text :summary
      t.text :description

      t.timestamps
    end
  end
end
