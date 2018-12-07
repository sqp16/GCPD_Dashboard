json.array!(@investigation_notes) do |investigation_note|
  json.extract! investigation_note, :id, :officer_id, :investigation_id, :content, :date
  json.url investigation_note_url(investigation_note, format: :json)
end