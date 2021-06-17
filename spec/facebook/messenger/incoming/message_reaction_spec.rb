require 'spec_helper'

describe Facebook::Messenger::Incoming::MessageReaction do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 145_776_419_762_7,
      'reaction' => {
        'action' => 'react',
        'emoji' => '👍',
        'reaction' => 'like'
      }
    }
  end

  subject { Facebook::Messenger::Incoming::MessageReaction.new(payload) }

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

  describe '.action' do
    it 'returns the reaction action' do
      expect(subject.action).to eq(payload['reaction']['action'])
    end
  end

  describe '.emoji' do
    it 'returns the reaction emoji' do
      expect(subject.emoji).to eq(payload['reaction']['emoji'])
    end
  end

  describe '.reaction' do
    it 'returns the reaction reaction' do
      expect(subject.reaction).to eq(payload['reaction']['reaction'])
    end
  end
end
