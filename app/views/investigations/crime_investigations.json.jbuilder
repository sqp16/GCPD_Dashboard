json.array!(@crime_investigations) do |crime_investigation|
  json.extract! crime_investigation, :id, :crime_id, :investigation_id, :crime_name
  json.url crime_investigation_url(crime_investigation, format: :json)
end