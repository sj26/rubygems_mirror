class AddFullNameToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :full_name, :string, after: :platform
  end
end
