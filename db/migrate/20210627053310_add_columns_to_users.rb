class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :employee_number, :integer
    add_column :users, :uid, :integer
    add_column :users, :superior, :boolean, default: false
    add_column :users, :designated_work_start_time, :datetime, default: Time.current.change(hour: 7, min: 30, sec: 0)
    add_column :users, :designated_work_end_time, :datetime, default: Time.current.change(hour: 7, min: 30, sec: 0)
    add_column :users, :month_sperior, :string
    add_column :users, :month_status, :string
    add_column :users, :apply_month, :string
    add_column :users, :month_modify, :boolean, default: false
  end
end
