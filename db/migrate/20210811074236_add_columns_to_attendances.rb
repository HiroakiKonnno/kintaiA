class AddColumnsToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :before_changed_started_at, :datetime
    add_column :attendances, :before_changed_finished_at, :datetime
    add_column :attendances, :month_sperior, :string
    add_column :attendances, :month_status, :string
    add_column :attendances, :month_modify, :boolean, default: false
    add_column :attendances, :day_modify, :boolean, default: false
    add_column :attendances, :day_status, :string
    add_column :attendances, :day_tomorrow, :boolean, default: false
    add_column :attendances, :day_sperior, :string
    add_column :attendances, :overwork_status, :string
    add_column :attendances, :overwork_tomorrow, :boolean, default: false
    add_column :attendances, :overwork_time, :datetime
    add_column :attendances, :overwork_note, :string
    add_column :attendances, :overwork_sperior, :string
    add_column :attendances, :overwork_modify, :boolean, default: false
  end
end
