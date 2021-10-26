module DnsRecords
  class Create
    def initialize(params)
      @params = HashWithIndifferentAccess.new(params)
    end

    def run
      hostnames = hostnames_attributes.map do |hostname_attribute|
        Hostname.find_or_initialize_by(hostname: hostname_attribute[:hostname])
      end

      self.dns_record = DnsRecord.create(ip: params[:ip], hostnames: hostnames)

      self
    end

    def success?
      dns_record.persisted?
    end

    def payload
      dns_record
    end

    private

    attr_accessor :dns_record
    attr_reader :params

    def hostnames_attributes
      @hostnames_attributes ||= params[:hostnames_attributes]
    end
  end
end
