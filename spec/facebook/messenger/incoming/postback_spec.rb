require 'spec_helper'

describe Facebook::Messenger::Incoming::Postback do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 145_776_419_762_7,
      'postback' => {
        'payload' => 'USER_DEFINED_PAYLOAD'
      }
    }
  end

  subject { Facebook::Messenger::Incoming::Postback.new(payload) }

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

  describe '.payload' do
    it 'returns the payload of the postback' do
      expect(subject.payload).to eq(payload['postback']['payload'])
    end
  end
end
