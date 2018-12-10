json.array!(@crime_investigations) do |crime_investigation|
  json.extract! crime_investigation, :crime
end