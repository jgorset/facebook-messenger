require 'spec_helper'

describe Facebook::Messenger::Incoming::AccountLinking do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 145_776_419_762_7,
      'account_linking' => {
        'status' => 'linked',
        'authorization_code' => 'PASS_THROUGH_AUTHORIZATION_CODE'
      }
    }
  end

  subject { Facebook::Messenger::Incoming::AccountLinking.new(payload) }

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

  describe '.status' do
    it 'returns linking status defined with the entry point' do
      expect(subject.status).to eq(payload['account_linking']['status'])
    end
  end

  describe '.authorization_code' do
    it 'returns authorization code defined with the entry point' do
      expect(subject.authorization_code)
        .to eq(payload['account_linking']['authorization_code'])
    end
  end
end
