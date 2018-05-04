require 'spec_helper'

describe Facebook::Messenger::Incoming::Optin do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 145_776_419_762_7,
      'optin' => {
        'ref' => 'PASS_THROUGH_PARAM',
        'user_ref' => 'UNIQUE_REF_PARAM'
      }
    }
  end

  subject { Facebook::Messenger::Incoming::Optin.new(payload) }

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
    it 'returns when the postback was sent' do
      expect(subject.sent_at).to eq(Time.at(payload['timestamp'] / 1000))
    end
  end

  describe '.ref' do
    it 'returns the data-ref defined with the entry point' do
      expect(subject.ref).to eq(payload['optin']['ref'])
    end
  end

  describe '.user_ref' do
    it 'returns the user_ref defined with the entry point' do
      expect(subject.user_ref).to eq(payload['optin']['user_ref'])
    end
  end
end
