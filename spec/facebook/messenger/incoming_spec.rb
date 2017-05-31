require 'spec_helper'

describe Facebook::Messenger::Incoming do
  describe '.parse' do
    context 'when the payload is unknown' do
      let :payload do
        {
          'foo' => 'bar'
        }
      end

      it 'raises UnknownPayload' do
        expect { subject.parse(payload) }.to raise_error(
          Facebook::Messenger::Incoming::UnknownPayload, payload.to_s
        )
      end
    end

    context 'when the payload is a message' do
      let :payload do
        {
          'sender' => {
            'id' => '2'
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

      it 'returns an Incoming::Message' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::Message
        )
      end
    end

    context 'when the payload is a message echo' do
      let :payload do
        {
          'sender' => {
            'id' => '2'
          },
          'recipient' => {
            'id' => '3'
          },
          'timestamp' => 145_776_419_762_7,
          'message' => {
            'is_echo' => true,
            'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
            'seq' => 73,
            'text' => 'Hello, bot!'
          }
        }
      end

      it 'returns an Incoming::MessageEcho' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::MessageEcho
        )
      end
    end

    context 'when the payload is a delivery' do
      let :payload do
        {
          'sender' => {
            'id' => '3'
          },
          'recipient' => {
            'id' => '3'
          },
          'delivery' => {
            'mids' => [
              'mid.1457764197618:41d102a3e1ae206a38',
              'mid.1458668856218:ed81099e15d3f4f233'
            ],
            'watermark' => 145_866_885_625_3,
            'seq' => 37
          }
        }
      end

      it 'returns an Incoming::Delivery' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::Delivery
        )
      end
    end

    context 'when the payload is a postback' do
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

      it 'returns an Incoming::Postback' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::Postback
        )
      end
    end

    context 'when the payload is an optin' do
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
            'ref' => 'PASS_THROUGH_PARAM'
          }
        }
      end

      it 'returns an Incoming::Optin' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::Optin
        )
      end
    end

    context 'when the payload is a read' do
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

      it 'returns an Incoming::Read' do
        expect(subject.parse(payload)).to be_a(
          Facebook::Messenger::Incoming::Read
        )
      end
    end
  end
end
