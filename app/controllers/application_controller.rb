class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :basic_auth, if: :production?
  before_action :category_variable, unless: :devise_controller?
  before_action :set_query

  private

  def production?
    Rails.env.production?
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  # TODO:リダイレクト先の分岐
  def after_sign_up_path_for(resource)
    root_path
  end

  # TODO:リダイレクト先の分岐
  def after_sign_in_path_for(resource)
    root_path
  end

  def category_variable
    @categories = Category.eager_load(children: :children).where(parent_id: 0)
  end

  def set_query
    @query = Item.ransack(params[:q])
    @keyword_sym = :name_or_description_or_brand_or_category_name_or_category_parent_name_or_category_grandparent_name_cont
  end
end
