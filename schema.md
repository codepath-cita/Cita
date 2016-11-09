# Cita Schema

## user
- id
- first_name
- last_name
- avatar_url
- email
- token
- created_at
- updated_at

## activity
- id
- name
- description
- image_url
- latitude
- longitude
- start_time
- end_time
- address_id
- chat_id
- created_at
- updated_at

## address
- id
- street1
- street2
- city
- state
- zip
- country
- created_at
- updated_at

## tag
- id
- text
- autocomplete
- created_at
- updated_at

## message
- id
- text
- user_id
- activity_id
- created_at
- updated_at

## attendees
- id
- user_id
- activity_id
- created_at
- updated_at

## tags_users
- id
- tag_id
- user_id
- created_at
- updated_at

## activities_tags
- id
- activity_id
- tag_id
- created_at
- updated_at


