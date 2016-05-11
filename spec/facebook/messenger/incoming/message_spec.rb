require 'spec_helper'

describe Facebook::Messenger::Incoming::Message do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 145_776_419_762_7,
      'message' => {
        'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
        'seq' => 73,
        'text' => 'Hello, bot!'
      }
    }
  end

  subject { Facebook::Messenger::Incoming::Message.new(payload) }

  describe '.raw_payload' do
    it 'returns the original payload' do
      expect(subject.raw_payload).to eq(payload)
    end
  end

  describe '.id' do
    it 'returns the message id' do
      expect(subject.id).to eq(payload['message']['mid'])
    end
  end

  describe '.sender' do
    it 'returns the sender' do
      expect(subject.sender).to eq(payload['sender'])
    end
  end

  describe '.seq' do
    it 'returns the message sequence number' do
      expect(subject.seq).to eq(payload['message']['seq'])
    end
  end

  describe '.sent_at' do
    it 'returns when the message was sent' do
      expect(subject.sent_at).to eq(Time.at(payload['timestamp'] / 1000))
    end
  end

  describe '.text' do
    it 'returns the text of the message' do
      expect(subject.text).to eq(payload['message']['text'])
    end
  end
end
