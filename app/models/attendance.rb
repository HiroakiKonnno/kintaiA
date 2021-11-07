class Attendance < ApplicationRecord
  belongs_to :user
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  validate :finished_at_is_invalid_without_started_at
  validate :started_at_than_finished_at_fast_if_invalid
  validate :before_changed_finished_at_is_invalid_without_a_started_at
  validate :before_changed_started_at_than_finished_at_fast_if_invalid

  def finished_at_is_invalid_without_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at && day_tomorrow != true
    end
  end

  def before_changed_finished_at_is_invalid_without_a_started_at
    errors.add(:before_changed_started_at, "が必要です") if before_changed_started_at.blank? && before_changed_finished_at.present?
    errors.add(:before_changed_finished_at, "が必要です") if before_changed_finished_at.blank? && before_changed_started_at.present?
  end
  
  
  def before_changed_started_at_than_finished_at_fast_if_invalid
    if before_changed_started_at.present? && before_changed_finished_at.present?
      errors.add(:before_changed_started_at, "より早い退勤時間は無効です") if before_changed_started_at > before_changed_finished_at && day_tomorrow != true
    end
  end
  
  
end
