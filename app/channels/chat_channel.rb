class ChatChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info("🔥 Params từ client: #{params.inspect}") # Debug xem có nhận đúng không

    room_id = params[:room_id]  # ✅ Lấy đúng room_id từ client
    stream_from "chat_#{room_id}"
    
    
  end

  def receive(data)
    room_id = params[:room_id]  # ✅ Lấy đúng room_id từ client

    if data["user"].present? && data["text"].present?
      Rails.logger.info("Room ID: #{room_id}") # ✅ Debug
      message_data = { user: data["user"], text: data["text"] }
      ActionCable.server.broadcast("chat_#{room_id}", message_data)
    else
      Rails.logger.error("❌ Lỗi: Tin nhắn không hợp lệ: #{data.inspect}")
    end
  end

  private

 
end
