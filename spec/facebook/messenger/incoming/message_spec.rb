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
        'is_echo' => false,
        'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
        'seq' => 73,
        'text' => 'Hello, bot!',
        'quick_reply' => {
          'payload' => 'Hi, I am a quick reply!'
        },
        'attachments' => [{
          'type' => 'image',
          'payload' => {
            'url' => 'https://www.example.com/1.jpg'
          }
        }]
      }
    }
  end

  subject { Facebook::Messenger::Incoming::Message.new(payload) }

  describe '.messaging' do
    it 'returns the original payload' do
      expect(subject.messaging).to eq(payload)
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

  describe '.recipient' do
    it 'returns the recipient' do
      expect(subject.recipient).to eq(payload['recipient'])
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

  describe '.echo?' do
    it 'returns the echo status of the message' do
      expect(subject.echo?).to eq(payload['message']['is_echo'])
    end
  end

  describe '.attachments' do
    it 'returns the message attachments' do
      expect(subject.attachments).to eq(payload['message']['attachments'])
    end
  end

  describe '.quick_reply' do
    context 'when a quick reply was used' do
      it 'returns the payload of the quick reply' do
        expect(subject.quick_reply).to eq(
          payload['message']['quick_reply']['payload']
        )
      end
    end

    context 'when a quick reply was not used' do
      before do
        payload['message'].delete('quick_reply')
      end

      it 'returns nil' do
        expect(subject.quick_reply).to eq(nil)
      end
    end
  end
end
