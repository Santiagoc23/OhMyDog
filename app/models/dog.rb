class Dog < ApplicationRecord
  belongs_to :user,  optional: true
  has_many :appointment, dependent: :destroy
  validates :name, uniqueness: { scope: :user_id, case_sensitive: false, message: "El nombre ya está en uso para este usuario" }
  validates :gender, inclusion: { in: ['Macho', 'Hembra'], message: "El sexo solo puede ser 'Macho' o 'Hembra'" }
  validates :age, allow_blank: true, numericality: { only_integer: true}
  validate :birthdate_or_age_present
  validate :birthdate_cannot_be_in_the_future
  validate :user_must_exist

  private

  def birthdate_cannot_be_in_the_future
    if birthdate.present? && birthdate > Date.current
      errors.add(:birthdate, "No se puede ingresar una fecha posterior a la actual.")
    end
  end

  def birthdate_or_age_present
    if birthdate.blank? && age.blank?
      errors.add(:birthdate, "Debes proporcionar la fecha de nacimiento o la edad")
    end
  end

  def user_must_exist
    if user.nil?
      errors.add(:user, 'El DNI debe pertenecer a un cliente.')
    end
  end
end