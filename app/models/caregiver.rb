class Caregiver < ApplicationRecord
  validates :phoneNum, presence: true, format: { with: /\A\d+\z/, message: "El télefono solo puede números, revise el campo e inténtelo nuevamente. "}
  has_many :users, dependent: :nullify

  has_many :reported_caregiver_associations, class_name: 'ReportedCaregiver', foreign_key: 'caregiver_id'
  has_many :reporting_users, through: :reported_caregiver_associations, dependent: :nullify
end
