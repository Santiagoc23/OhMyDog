class Donation < ApplicationRecord
    validates :title, presence: true
    validates :description, presence: true
    validates :closing_date, presence: true
    validate :closing_date_cannot_be_in_the_past_or_present
    validates :target_amount, presence: true, numericality: { greater_than: 0, message: 'El valor ingresado no es valido'}
    validates :amount, numericality: { greater_than: 0, message: 'El valor ingresado no es valido' }, allow_nil: true

    private
    def closing_date_cannot_be_in_the_past_or_present
        if closing_date.present? && closing_date <= Date.current
            errors.add(:closing_date, 'La fecha ingresada no es valida, asegúrese de que sea una fecha futura.')
        end
    end

end
