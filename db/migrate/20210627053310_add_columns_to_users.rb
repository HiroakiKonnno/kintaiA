class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :employee_number, :integer
    add_column :users, :uid, :integer
    add_column :users, :superior, :boolean, default: false
    add_column :users, :designated_work_start_time, :datetime, default: Time.current.change(hour: 7, min: 30, sec: 0)
    add_column :users, :designated_work_end_time, :datetime, default: Time.current.change(hour: 7, min: 30, sec: 0)
  end
end