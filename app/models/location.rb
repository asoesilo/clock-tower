class Location < ActiveRecord::Base
  CA_HOLIDAY_CODES = ["ca", "ca_qc", "ca_ab", "ca_on", "ca_sk", "ca_mb", "ca_ns", "ca_pe", "ca_bc", "ca_nf", "ca_nt", "ca_nu", "ca_nb", "ca_yk", "us"]
  # Taken from the Holidays::CA namespace.
  
  belongs_to :creator, class_name: :User, foreign_key: "user_id"

  validates :name, presence: true
  validates :holiday_code, inclusion: { in: CA_HOLIDAY_CODES }
  validates :tax_percent, numericality: true
  validates :tax_name, presence: true
end