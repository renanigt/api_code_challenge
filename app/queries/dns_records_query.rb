class DnsRecordsQuery
  def initialize(params: {}, page: 1, per_page: 10)
    @params = HashWithIndifferentAccess.new(params)
    @page = page
    @per_page = per_page.to_i
  end

  def run
    {
      total_records: dns_records.length,
      records: dns_records.map { |result| { id: result.id, ip_address: result.ip } },
      related_hostnames: related_hostnames
    }
  end

  private

  attr_reader :params, :page, :per_page

  def dns_records
    @_dns_records ||= begin
      result = included_hostnames.present? ? included_hostnames_query : DnsRecord.all
      result = result.where.not(id: excluded_hostnames_query.pluck(:id)) if excluded_hostnames.present?
      result.limit(per_page).offset(per_page * (page - 1))
    end
  end

  def related_hostnames
    @_related_hostnames ||= begin
      hostnames = dns_records.map(&:hostnames).flatten.map(&:hostname)
      hostnames = hostnames.select { |hostname| included_hostnames.include?(hostname) } if included_hostnames.present?
      hostnames.uniq.map do |hostname|
        {
          hostname: hostname,
          count: hostnames.count(hostname)
        }
      end
    end
  end

  def included_hostnames_query
    @_included_hostnames_query ||= begin
      DnsRecord.with_hostname(included_hostnames)
        .group(:id)
        .having('count(hostnames) = ?', included_hostnames.count)
    end
  end

  def excluded_hostnames_query
    @_excluded_hostnames_query ||= DnsRecord.with_hostname(excluded_hostnames)
  end

  def included_hostnames
    @_included_hostnames ||= params[:included]
  end

  def excluded_hostnames
    @_excluded_hostnames ||= params[:excluded]
  end

  def offset
    per_page * (page - 1)
  end
end

