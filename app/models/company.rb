class Company < ApplicationRecord
  has_rich_text :description

  validates :email, format: { with: /\b[A-Z0-9._%a-z\-]+@getmainstreet\.com\z/,  message: "domain should be getmainstreet.com" }, allow_blank: true, uniqueness: true

  before_save :fetch_city_state, if: :zip_code_changed?

  def fetch_city_state
    address = ZipCodes.identify(zip_code)
    if address.present?
      self.city = address[:city]
      self.state = address[:state_name] + " (" + address[:state_code] + ")"
    else
      logger.info 'Invalid Zip code.'
    end
  end

end
