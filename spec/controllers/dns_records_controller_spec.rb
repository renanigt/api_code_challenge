require 'rails_helper'

RSpec.describe Api::V1::DnsRecordsController, type: :controller do
  let(:parsed_body) { JSON.parse(response.body, symbolize_names: true) }

  describe '#index' do
    context 'with the required page param' do
      let(:page) { 1 }

      let(:ip1) { '1.1.1.1' }
      let(:ip2) { '2.2.2.2' }
      let(:ip3) { '3.3.3.3' }
      let(:ip4) { '4.4.4.4' }
      let(:ip5) { '5.5.5.5' }
      let(:lorem) { 'lorem.com' }
      let(:ipsum) { 'ipsum.com' }
      let(:dolor) { 'dolor.com' }
      let(:amet) { 'amet.com' }
      let(:sit) { 'sit.com' }

      let(:payload1) do
        {
          dns_records: {
            ip: ip1,
            hostnames_attributes: [
              {
                hostname: lorem
              },
              {
                hostname: ipsum
              },
              {
                hostname: dolor
              },
              {
                hostname: amet
              }
            ]
          }
        }.to_json
      end

      let(:payload2) do
        {
          dns_records: {
            ip: ip2,
            hostnames_attributes: [
              {
                hostname: ipsum
              }
            ]
          }
        }.to_json
      end

      let(:payload3) do
        {
          dns_records: {
            ip: ip3,
            hostnames_attributes: [
              {
                hostname: ipsum
              },
              {
                hostname: dolor
              },
              {
                hostname: amet
              }
            ]
          }
        }.to_json
      end

      let(:payload4) do
        {
          dns_records: {
            ip: ip4,
            hostnames_attributes: [
              {
                hostname: ipsum
              },
              {
                hostname: dolor
              },
              {
                hostname: sit
              },
              {
                hostname: amet
              }
            ]
          }
        }.to_json
      end

      let(:payload5) do
        {
          dns_records: {
            ip: ip5,
            hostnames_attributes: [
              {
                hostname: dolor
              },
              {
                hostname: sit
              }
            ]
          }
        }.to_json
      end

      before do
        request.accept = 'application/json'
        request.content_type = 'application/json'

        post(:create, body: payload1, format: :json)
        post(:create, body: payload2, format: :json)
        post(:create, body: payload3, format: :json)
        post(:create, body: payload4, format: :json)
        post(:create, body: payload5, format: :json)
      end

      context 'without included and excluded optional params' do
        let(:expected_response) do
          {
            total_records: 5,
            records: [
              {
                id: 6,
                ip_address: ip1
              },
              {
                id: 7,
                ip_address: ip2
              },
              {
                id: 8,
                ip_address: ip3
              },
              {
                id: 9,
                ip_address: ip4
              },
              {
                id: 10,
                ip_address: ip5
              }
            ],
            related_hostnames: [
              {
                count: 1,
                hostname: lorem
              },
              {
                count: 4,
                hostname: ipsum
              },
              {
                count: 4,
                hostname: dolor
              },
              {
                count: 3,
                hostname: amet
              },
              {
                count: 2,
                hostname: sit
              }
            ]
          }
        end

        before :each do
          get(:index, params: { page: page })
        end

        it 'responds with valid response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns all dns records with all hostnames' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'with the included optional param' do
        let(:included) { [lorem] }

        let(:expected_response) do
          {
            total_records: 1,
            records: [
              {
                id: 16,
                ip_address: ip1
              }
            ],
            related_hostnames: [
              {
                count: 1,
                hostname: ipsum
              },
              {
                count: 1,
                hostname: dolor
              },
              {
                count: 1,
                hostname: amet
              }
            ]
          }
        end

        before :each do
          get(:index, params: { page: page, included: included })
        end

        it 'responds with valid response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns only the included dns records without a related hostname' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'with the excluded optional param' do
        let(:excluded) { [lorem] }

        let(:expected_response) do
          {
            total_records: 4,
            records: [
              {
                id: 27,
                ip_address: ip2
              },
              {
                id: 28,
                ip_address: ip3
              },
              {
                id: 29,
                ip_address: ip4
              },
              {
                id: 30,
                ip_address: ip5
              }
            ],
            related_hostnames: [
              {
                count: 3,
                hostname: ipsum
              },
              {
                count: 3,
                hostname: dolor
              },
              {
                count: 2,
                hostname: amet
              },
              {
                count: 2,
                hostname: sit
              }
            ]
          }
        end

        before :each do
          get(:index, params: { page: page, excluded: excluded })
        end

        it 'responds with valid response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns only the non-excluded dns records with a related hostname' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'with both included and excluded optional params' do
        let(:included) { [ipsum, dolor] }
        let(:excluded) { [sit] }

        let(:expected_response) do
          {
            total_records: 2,
            records: [
              {
                id: 36,
                ip_address: ip1
              },
              {
                id: 38,
                ip_address: ip3
              }
            ],
            related_hostnames: [
              {
                count: 1,
                hostname: lorem
              },
              {
                count: 2,
                hostname: amet
              }
            ]
          }
        end

        before :each do
          get(:index, params: { page: page, included: included, excluded: excluded })
        end

        it 'responds with valid response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns only the non-excluded dns records with a related hostname' do
          expect(parsed_body).to eq expected_response
        end
      end
    end

    context 'without the required page param' do
      before :each do
        get(:index)
      end

      it 'responds with unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '#create' do
    subject { post :create, params: params, format: :json }

    context 'with valid params' do
      let(:params) do
        {
          dns_records: {
            ip: '123.1.1.2',
            hostnames_attributes: [
              { hostname: 'www.test1.com' },
              { hostname: 'www.test2.com' },
              { hostname: 'www.test3.com' },
              { hostname: 'www.test4.com' }
            ]
          }
        }
      end

      it 'returns status 200(ok)' do
        subject

        expect(response).to have_http_status(:ok)
      end

      it 'creates dns records and related hostnames' do
        expect { subject }.to change { DnsRecord.count }.by(1)
          .and change { Hostname.count }.by(4)
      end

      it 'returns json containing dns record id' do
        subject

        dns_record = DnsRecord.find(parsed_body[:id])

        expect(dns_record.ip).to eq('123.1.1.2')
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          dns_records: {
            ip: '',
            hostnames_attributes: [
              { hostname: 'www.test1.com' },
              { hostname: 'www.test2.com' },
              { hostname: 'www.test3.com' },
              { hostname: 'www.test4.com' }
            ]
          }
        }
      end

      it 'returns status 422(unprocessable_entity)' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create dns records and related hostnames' do
        expect { subject }.not_to change { DnsRecord.count }
      end

      it 'returns json containing errors' do
        subject

        expect(parsed_body[:errors]).to eq({
          ip: ["can't be blank"]
        })
      end
    end
  end
end