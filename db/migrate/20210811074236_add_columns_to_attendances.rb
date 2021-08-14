class AddColumnsToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :before_changed_started_at, :datetime
    add_column :attendances, :before_changed_finished_at, :datetime
  end
end
