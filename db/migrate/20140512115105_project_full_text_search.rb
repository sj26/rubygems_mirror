class ProjectFullTextSearch < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX projects_name_fts_idx
        ON projects
        USING gin(to_tsvector('english', "projects"."name"::text));
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX projects_name_fts_idx;
    SQL
  end
end
