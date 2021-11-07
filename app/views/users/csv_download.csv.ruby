require 'csv'
CSV.generate do |csv|
  column_names = %w(日付 出社時間 退社時間)
  csv << column_names
  @attendances.each do |a|
    column_values = [
      if a.worked_on.present?
        a.worked_on.strftime
      end,
      if a.started_at.present?
        a.started_at.strftime
      end, 
      if a.finished_at.present?
        a.finished_at.strftime
      end
    ]
    csv << column_values
  end
end