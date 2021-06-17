require 'spec_helper'

describe Facebook::Messenger::Incoming::MessageRequest do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 145_776_419_762_7,
      'message_request' => 'accept'
    }
  end

  subject { Facebook::Messenger::Incoming::MessageRequest.new(payload) }

  describe '.messaging' do
    it 'returns the original payload' do
      expect(subject.messaging).to eq(payload)
    end
  end

  describe '.accept?' do
    it 'returns true when accepted' do
      expect(subject.accept?).to be true
    end
  end
end
