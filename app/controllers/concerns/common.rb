module Common
  extend ActiveSupport::Concern

  private

  def move_to_root
    redirect_to root_path unless user_signed_in?
  end

  def to_boolean(string)
    if string == 'true'
      true
    elsif string == 'false'
      false
    end
  end
end
