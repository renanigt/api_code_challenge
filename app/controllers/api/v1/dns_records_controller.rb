module Api
  module V1
    class DnsRecordsController < ApplicationController
      # GET /dns_records
      def index
        render json: DnsRecordsQuery.new(params: { included: params[:included], excluded: params[:excluded] }, page: page.to_i).run
      end

      # POST /dns_records
      def create
        dns_record_service = DnsRecords::Create.new(dns_records_params).run

        if dns_record_service.success?
          render json: { id: dns_record_service.payload.id }
        else
          render json: { errors: dns_record_service.payload.errors }, status: :unprocessable_entity
        end
      end

      private

      def dns_records_params
        params.require(:dns_records).permit(:ip, hostnames_attributes: [ :hostname ])
      end

      def page
        params.require(:page)
      end
    end
  end
end
