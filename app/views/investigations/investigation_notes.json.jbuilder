json.array!(@investigation_notes) do |investigation_note|
  json.extract! investigation_note, :note, :officer, :url
end