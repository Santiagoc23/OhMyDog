json.extract! health_record, :id, :created_at, :updated_at
json.url health_record_url(health_record, format: :json)
