class Api::V1::PushersController < Api::BaseController
  def auth
    response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
      user_id: current_api_user.id,
      user_info: {
        name: current_api_user.full_name,
        email: current_api_user.email,
        avatar: current_api_user.avatar
      }
    })
    render :json => response
  end
end