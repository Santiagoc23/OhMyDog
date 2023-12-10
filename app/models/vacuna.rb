class Vacuna < ApplicationRecord
  
    validates :fechaAct, presence: { message: "Se requiere seleccionar la fecha de consulta." }
    validates :peso, presence: { message: "Se requiere completar el peso del perro." }
    validate :validate_dog_age_for_type_a
    validate :validate_dog_age_for_type_b
  
    private
  
    def validate_dog_age_for_type_a
      if tipoVacuna == 'Vacunación tipo A (enfermedad)' && age.to_i < 2
        errors.add(:base, 'Solo Solo es posible darle una vacuna de tipo A a un perro mayor o igual a 2 meses de edad.')
      end
    end
  
    def validate_dog_age_for_type_b
      if tipoVacuna.include?('Vacunación tipo B') && age.to_i < 4
        errors.add(:base, 'Solo Solo es posible darle una vacuna de tipo B a un perro mayor o igual a 4 meses de edad.')
      end
    end
  end