class Location < ActiveRecord::Base
  HOLIDAY_CODES = {
    "Quebec" => "ca_qc", "Alberta" => "ca_ab", "Ontario" => "ca_on", 
    "Saskatchewan" => "ca_sk", "Manitoba" => "ca_mb", "Nova Scotia" => "ca_ns",
    "Prince Edward Island" => "ca_pe", "British Columbia" => "ca_bc", 
    "Newfoundland and Labrador" => "ca_nf", "Northwest Territories" => "ca_nt", 
    "Nunavut" => "ca_nu", "New Brunswick" => "ca_nb", "Yukon" => "ca_yk" }
  # Taken from the Holidays::CA namespace.
  
  belongs_to :creator, class_name: :User, foreign_key: "user_id"
  has_many :projects
  has_many :users

  validates :name, presence: true
  validates :province, inclusion: { in: HOLIDAY_CODES.keys }
  validates :tax_percent, numericality: true
  validates :tax_name, presence: true

  before_destroy :check_if_deletable

  def to_s
    "#{name} - #{province}"
  end

  def holiday_code
    HOLIDAY_CODES[self.province].to_sym
  end

  private

  def check_if_deletable
    self.errors.add :projects, "are present." if projects.any?
    self.errors.add :users, "are present." if users.any?
    errors.blank?
  end

end