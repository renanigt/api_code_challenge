class DnsRecord < ApplicationRecord
  has_and_belongs_to_many :hostnames

  validates :ip, presence: true

  scope :with_hostname, -> (hostnames) { joins(:hostnames).where( hostnames: { hostname: hostnames } ) }

  accepts_nested_attributes_for :hostnames
end
