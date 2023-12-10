json.extract! donation, :id, :title, :description, :closing_date, :target_amount, :amount, :created_at, :updated_at
json.url donation_url(donation, format: :json)
