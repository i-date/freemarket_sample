class UserDetail
  include ActiveModel::Model

  attr_accessor  :nickname, :body, :last_name, :first_name, :last_name_kana, :first_name_kana, :birth_year, :birth_month, :birth_day, :phone_number, :zipcode, :prefecture, :city, :block, :building

  def initialize(attributes={})
    super
  end

  def user_params
    {
      nickname: self.nickname
    }
  end

  def profile_params
    {
      body:            self.body,
      last_name:       self.last_name,
      first_name:      self.first_name,
      last_name_kana:  self.last_name_kana,
      first_name_kana: self.first_name_kana,
      birth_year:      self.birth_year,
      birth_month:     self.birth_month,
      birth_day:       self.birth_day,
      phone_number:    self.phone_number,
      zipcode:         self.zipcode,
      prefecture:      self.prefecture,
      city:            self.city,
      block:           self.block,
      building:        self.building
    }
  end
end
