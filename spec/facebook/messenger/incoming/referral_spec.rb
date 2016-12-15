require 'spec_helper'

describe Facebook::Messenger::Incoming::Referral do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 1_458_692_752_478,
      'referral' => {
        'ref' => 'my-ref-value',
        'source' => 'SHORTLINK',
        'type' => 'OPEN_THREAD'
      }
    }
  end

  subject { Facebook::Messenger::Incoming::Referral.new(payload) }

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

  describe '.referral' do
    it 'returns the ref value' do
      expect(subject.referral.ref).to eq(payload['referral']['ref'])
    end

    it 'returns the source value' do
      expect(subject.referral.source).to eq(payload['referral']['source'])
    end

    it 'returns the type value' do
      expect(subject.referral.type).to eq(payload['referral']['type'])
    end
  end

  describe '.ref' do
    it 'returns the ref value' do
      expect(subject.ref).to eq(payload['referral']['ref'])
    end
  end
end
