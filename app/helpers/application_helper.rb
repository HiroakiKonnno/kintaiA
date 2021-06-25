module ApplicationHelper
  def full_title(page_name = "")
    base_title = "Kintai_app"
    if page_name.empty?
      base_title
    else
      page_name + " | " + base_title
    end
  end
  
  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出社' if attendance.started_at.nil?
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    return false
  end
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
end

