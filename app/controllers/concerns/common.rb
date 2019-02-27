module Common
  extend ActiveSupport::Concern

  private

  def move_to_root
    redirect_to root_path unless user_signed_in?
  end

  def set_years
    min_year = Time.new.year.to_s[2,2].to_i
    max_year = min_year + 10
    return years = [*(min_year..max_year)]
  end

  def set_months
    ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
  end
end
