json.extract! recent_event, :id, :title, :image, :description, :created_at, :updated_at
json.url recent_event_url(recent_event, format: :json)
