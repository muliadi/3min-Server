collection @chats
attributes :product_id, :from, :to, :chat_id

node(:message) { |pc| pc.chat.message }
node(:sent_at) { |pc| pc.created_at.to_i }


