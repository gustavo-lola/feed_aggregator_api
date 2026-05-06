class ChangeReadToBooleanInFeedItems < ActiveRecord::Migration[8.1]
  def up

    add_column :feed_items, :read_tmp, :boolean, default: false, null: false

    reversible do |dir|
      dir.up do
        execute <<-SQL.squish
          UPDATE feed_items
          SET read_tmp = CASE WHEN read = 'true' THEN TRUE ELSE FALSE END
        SQL
      end
    end

    remove_column :feed_items, :read
    rename_column :feed_items, :read_tmp, :read
  end

  def down
    add_column :feed_items, :read_tmp_str, :string

    reversible do |dir|
      dir.up do
        execute <<-SQL.squish
          UPDATE feed_items
          SET read_tmp_str = CASE WHEN read = TRUE THEN 'true' ELSE 'false' END
        SQL
      end
    end

    remove_column :feed_items, :read
    rename_column :feed_items, :read_tmp_str, :read
  end
end
