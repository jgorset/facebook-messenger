require 'spec_helper'

describe Facebook::Messenger::Incoming::Payment do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 1_458_692_752_478,
      'payment' => {
        'payload' => 'DEVELOPER_DEFINED_PAYLOAD',
        'requested_user_info' => {
          'shipping_address' => {
            'street_1' => '1 Hacker Way',
            'street_2' => '',
            'city' => 'MENLO PARK',
            'state' => 'CA',
            'country' => 'US',
            'postal_code' => '94025'
          },
          'contact_name' => 'Peter Chang',
          'contact_email' => 'peter@anemailprovider.com',
          'contact_phone' => '+15105551234'
        },
        'payment_credential' => {
          'provider_type' => 'stripe',
          'charge_id' => 'ch_18tmdBEoNIH3FPJHa60ep123',
          'fb_payment_id' => '123456789'
        },
        'amount' => {
          'currency' => 'USD',
          'amount' => '29.62'
        },
        'shipping_option_id' => '123'
      }
    }
  end

  subject { Facebook::Messenger::Incoming::Payment.new(payload) }

  describe '.messaging' do
    it 'returns the original payload' do
      expect(subject.messaging).to eq(payload)
    end
  end

  describe '.sender' do
    it 'returns the sender' do
      expect(subject.sender).to eq(payload['sender'])
    end
  end

  describe '.recipient' do
    it 'returns the recipient' do
      expect(subject.recipient).to eq(payload['recipient'])
    end
  end

  describe '.sent_at' do
    it 'returns when the message was sent' do
      expect(subject.sent_at).to eq(Time.at(payload['timestamp'] / 1000))
    end
  end

  describe '.payment' do
    it 'returns the payload value' do
      expect(subject.payment.payload).to eq(payload['payment']['payload'])
    end

    it 'returns the requested_user_info value' do
      expect(subject.payment.user_info)
        .to eq(payload['payment']['requested_user_info'])
    end

    it 'returns the payment_credential value' do
      expect(subject.payment.payment_credential)
        .to eq(payload['payment']['payment_credential'])
    end

    it 'returns the amount value' do
      expect(subject.payment.amount).to eq(payload['payment']['amount'])
    end

    it 'returns the shipping_option_id value' do
      expect(subject.payment.shipping_option_id)
        .to eq(payload['payment']['shipping_option_id'])
    end
  end
end
