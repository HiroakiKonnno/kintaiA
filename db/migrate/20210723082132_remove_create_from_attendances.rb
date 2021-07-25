class RemoveCreateFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :worktime, :datetime
  end
end
