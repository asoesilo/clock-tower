class Location < ActiveRecord::Base
  HOLIDAY_CODES = {
    "Quebec" => "ca_qc", "Alberta" => "ca_ab", "Ontario" => "ca_on", 
    "Saskatchewan" => "ca_sk", "Manitoba" => "ca_mb", "Nova Scotia" => "ca_ns",
    "Prince Edward Island" => "ca_pe", "British Columbia" => "ca_bc", 
    "Newfoundland and Labrador" => "ca_nf", "Northwest Territories" => "ca_nt", 
    "Nunavut" => "ca_nu", "New Brunswick" => "ca_nb", "Yukon" => "ca_yk" }
  # Taken from the Holidays::CA namespace.
  
  belongs_to :creator, class_name: :User, foreign_key: "user_id"

  validates :name, presence: true
  validates :province, inclusion: { in: HOLIDAY_CODES.keys }
  validates :tax_percent, numericality: true
  validates :tax_name, presence: true

  before_create :set_holiday_code

  private

  def set_holiday_code
    self.holiday_code = HOLIDAY_CODES[self.province]
  end

end