require 'spec_helper'

describe Facebook::Messenger::Incoming::Read do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 145_776_419_762_7,
      'read' => {
        'watermark' => 145_866_885_625_3,
        'seq' => 38
      }
    }
  end

  subject { Facebook::Messenger::Incoming::Read.new(payload) }

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

  describe '.at' do
    it 'returns when the message was read' do
      expect(subject.at).to eq(Time.at(payload['read']['watermark'] / 1000))
    end
  end

  describe '.seq' do
    it 'returns the read sequence number' do
      expect(subject.seq).to eq(payload['read']['seq'])
    end
  end
end
