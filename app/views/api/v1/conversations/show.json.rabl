object @conversation

attributes :id, :product_id, :offer, :channel_name

child(:audience_one, if: lambda {|c| current_api_user.id != c.audience_one.id }) do
  attributes :id, :full_name, :facebook_avatar, :avatar
end

child(:audience_two, if: lambda {|c| current_api_user.id != c.audience_two.id }) do
  attributes :id, :full_name, :facebook_avatar, :avatar
end

child @conversation_replies => :replies do
  attributes :id, :conversation_id, :user_id, :reply
  node(:timestamp) { |r| r.created_at.to_i }
end