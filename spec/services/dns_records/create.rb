require 'rails_helper'

describe DnsRecords::Create do
  let(:params) do
    {
      ip: '123.1.1.2',
      hostnames_attributes: [
        { hostname: 'www.test1.com' },
        { hostname: 'www.test2.com' },
        { hostname: 'www.test3.com' },
        { hostname: 'www.test4.com' }
      ]
    }
  end

  subject { described_class.new(params).run }

  describe '#run' do
    context 'with valid params' do
      let(:params) do
        {
          ip: '123.1.1.2',
          hostnames_attributes: [
            { hostname: 'www.test1.com' },
            { hostname: 'www.test2.com' },
            { hostname: 'www.test3.com' },
            { hostname: 'www.test4.com' }
          ]
        }
      end

      it 'return true from success' do
        expect(subject.success?).to eq(true)
      end

      it 'creates dns records' do
        expect { subject }.to change { DnsRecord.count }.by(1)
          .and change { Hostname.count }.by(4)
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          ip: '123.1.1.2',
          hostnames_attributes: [
            { hostname: 'www.test1.com' },
            { hostname: '' },
            { hostname: 'www.test3.com' },
            { hostname: 'www.test4.com' }
          ]
        }
      end

      it 'return true from success' do
        expect(subject.success?).to eq(false)
      end

      it 'creates dns records' do
        expect { subject }.not_to change { DnsRecord.count }
      end
    end
  end
end
