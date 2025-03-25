module ApplicationHelper
  def image_path_valid?(path)
    return false unless path.present?
    return true if path =~ /\Ahttps?:\/\//

    Rails.application.assets.find_asset(path).present?
  rescue
    false
  end
end
