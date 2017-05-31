require 'spec_helper'

describe Facebook::Messenger::Incoming::MessageEcho do
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
        'is_echo' => true,
        'app_id' => 184_719_329_217_930_000,
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

  let :video_payload do
    {
      'sender' => {
        'id' => '5'
      },
      'recipient' => {
        'id' => '7'
      },
      'timestamp' => 145_776_419_762_4,
      'message' => {
        'is_echo' => true,
        'app_id' => 184_719_329_217_930_001,
        'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
        'attachments' => [{
          'type' => 'video',
          'payload' => {
            'url' => 'https://www.example.com/2.mp4'
          }
        }]
      }
    }
  end

  let :file_payload do
    {
      'sender' => {
        'id' => '5'
      },
      'recipient' => {
        'id' => '7'
      },
      'timestamp' => 145_776_412_762_4,
      'message' => {
        'is_echo' => true,
        'app_id' => 184_719_329_217_930_001,
        'mid' => 'mid.1457764197618:41d102a3e1ae206a39',
        'attachments' => [{
          'type' => 'file',
          'payload' => {
            'url' => 'https://www.example.com/3.pdf'
          }
        }]
      }
    }
  end

  let :audio_payload do
    {
      'sender' => {
        'id' => '8'
      },
      'recipient' => {
        'id' => '9'
      },
      'timestamp' => 145_776_419_732_4,
      'message' => {
        'is_echo' => true,
        'app_id' => 184_719_329_217_930_001,
        'mid' => 'mid.1457764197618:41d102a3e1ae206a48',
        'attachments' => [{
          'type' => 'audio',
          'payload' => {
            'url' => 'https://www.example.com/4.ogg'
          }
        }]
      }
    }
  end

  let :location_payload do
    {
      'sender' => {
        'id' => '6'
      },
      'recipient' => {
        'id' => '9'
      },
      'timestamp' => 145_776_429_762_4,
      'message' => {
        'is_echo' => true,
        'app_id' => 184_719_329_222_930_001,
        'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
        'attachments' => [{
          'type' => 'location',
          'payload' => {
            'coordinates' => {
              'lat' => '39.920_770',
              'long' => '40.920_770'
            }
          }
        }]
      }
    }
  end

  subject { Facebook::Messenger::Incoming::MessageEcho.new(payload) }

  describe '.messaging' do
    it 'returns the original payload' do
      expect(subject.messaging).to eq(payload)
    end
  end

  describe '.id' do
    it 'returns the message echo id' do
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
    it 'returns the message echo sequence number' do
      expect(subject.seq).to eq(payload['message']['seq'])
    end
  end

  describe '.sent_at' do
    it 'returns when the message echo was sent' do
      expect(subject.sent_at).to eq(Time.at(payload['timestamp'] / 1000))
    end
  end

  describe '.text' do
    it 'returns the text of the message echo' do
      expect(subject.text).to eq(payload['message']['text'])
    end
  end

  describe '.echo?' do
    it 'returns the echo status of the message echo' do
      expect(subject.echo?).to eq(payload['message']['is_echo'])
    end
  end

  describe '.attachments' do
    it 'returns the message echo attachments' do
      expect(subject.attachments).to eq(payload['message']['attachments'])
    end
  end

  describe '.image_attachment?' do
    it 'returns whether the attachment is an image' do
      expect(subject.image_attachment?).to be(true)
    end
  end

  describe '.video_attachment?' do
    subject { Facebook::Messenger::Incoming::MessageEcho.new(video_payload) }

    it 'returns whether the attachment is a video' do
      expect(subject.video_attachment?).to be(true)
    end
  end

  describe '.location_attachment?' do
    subject { Facebook::Messenger::Incoming::MessageEcho.new(location_payload) }

    it 'returns whether the attachment is a video' do
      expect(subject.location_attachment?).to be(true)
    end
  end

  describe '.audio_attachment?' do
    subject { Facebook::Messenger::Incoming::MessageEcho.new(audio_payload) }

    it 'returns whether the attachment is an audio' do
      expect(subject.audio_attachment?).to be(true)
    end
  end

  describe '.file_attachment?' do
    subject { Facebook::Messenger::Incoming::MessageEcho.new(file_payload) }

    it 'returns whether the attachment is a file' do
      expect(subject.file_attachment?).to be(true)
    end
  end

  describe '.location_coordinates' do
    subject { Facebook::Messenger::Incoming::MessageEcho.new(location_payload) }

    let(:attachments) { location_payload['message']['attachments'] }

    it 'returns array of lat long coordinates' do
      expect(subject.location_coordinates).to eq(
        [
          attachments.first['payload']['coordinates']['lat'],
          attachments.first['payload']['coordinates']['long']
        ]
      )
    end
  end

  describe '.attachment_type' do
    it 'returns the type of the attachment' do
      expect(subject.attachment_type).to eq(
        payload['message']['attachments'].first['type']
      )
    end
  end

  describe '.attachment_url' do
    it 'returns the url of the attachment' do
      expect(subject.attachment_url).to eq(
        payload['message']['attachments'].first['payload']['url']
      )
    end
  end
  describe '.app_id' do
    it 'returns the app_id from which the message echo was sent' do
      expect(subject.app_id).to eq(payload['message']['app_id'])
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
