class AddColumnsToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :before_changed_started_at, :datetime
    add_column :attendances, :before_changed_finished_at, :datetime
    add_column :attendances, :month_sperior, :string
    add_column :attendances, :month_status, :string
    add_column :attendances, :month_modify, :boolean, default: false
  end
end
