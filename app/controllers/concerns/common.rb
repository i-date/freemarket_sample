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
    return [*(1..12)].map { |num| '%02d' % num }
  end
end
