class ReportedCaregiver < ApplicationRecord
  belongs_to :user
  belongs_to :caregiver

  # Resto del código...
end
