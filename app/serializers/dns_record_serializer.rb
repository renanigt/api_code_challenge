class DnsRecordSerializer
  SERIALIZED_ATTRIBUTES = %i(id ip)

  def initialize(dns_record)
    @dns_record = dns_record
  end

  def as_json
    attributes.merge(errors) if errors.present?
    attributes.merge({ hostnames:  }) if errors.present?

    attributes
  end

  def attributes
    {
      id: dns_record.id,
      ip_address: dns_record.ip,
      hostnames: dns_record&.hostnames&.map(&:hostname)
    }
  end

  private

  attr_reader :dns_record

  def hostnames_attributes
    {
      hostnames: 
    }
  end

  def errors
    dns_record.errors.as_json
  end
end
