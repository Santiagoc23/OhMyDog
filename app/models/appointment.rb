class Appointment < ApplicationRecord
  belongs_to :user
  validates :time, presence: { message: "No puede dejar el turno en blanco." }
  validate :future_time
  validate :it_isnt_sunday
  validate :time_within_valid_ranges

  private

  def future_time
    act= DateTime.now
    if !self.time.nil? && self.time<act
      errors.add(:time,"No tenemos forma de atender turnos viajando al pasado, por ahora, asi que por favor escoja una fecha valida.")
    end
  end

  def it_isnt_sunday
    if !self.time.nil? && self.time.sunday?
      errors.add(:time,"No trabajamos los domingos. Por favor, escoja otro dia.")
    end
  end

  def time_within_valid_ranges
    if time
      if (time.hour >= 9 && time.hour < 13) || (time.hour >= 14 && time.hour < 18)
        # La hora está dentro de los rangos válidos
      else
        errors.add(:time, "Trabajamos solamente entre las 9-13 o 14-18 horas. Por favor, escoja otro horario.")
      end
    end
  end

end
