json.extract! user, :id, :created_at, :updated_at
json.email_address user.email
json.url user_url(user, format: :json)
