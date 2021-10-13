module AttendancesHelper
  
def attendances_invalid?
    attendances = true
    attendances_params.each do |id, item|
      if item[:started_at].blank? && item[:finished_at].blank?
        next
      elsif item[:started_at].blank? || item[:finished_at].blank?
        attendances = false
        break
      end
    end
    return attendances
  end
end

def over_time(endtime, format_work_end)
  format("%.2f", (((endtime - format_work_end) / 60) / 60.0))
end

