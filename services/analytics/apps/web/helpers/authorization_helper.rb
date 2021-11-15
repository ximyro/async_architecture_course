module AuthorizationHelper
  def current_user
    @current_user ||= UserRepository.new.find_by_id(session[:user_id])
  end
end
