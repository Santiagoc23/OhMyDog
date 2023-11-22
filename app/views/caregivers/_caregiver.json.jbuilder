json.extract! caregiver, :id, :name, :surname, :phoneNum, :email, :created_at, :updated_at
json.url caregiver_url(caregiver, format: :json)
