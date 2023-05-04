require 'spec_helper'

describe Facebook::Messenger::Incoming::Feed do
  let :payload do
     JSON.parse({
        "value": {
            "from": {
                "id": "100518329516574",
                "name": "Vit Service"
            },
            "message": "post 8",
            "post_id": "100518329516574_194260390126069",
            "created_time": 1682963527,
            "item": "status",
            "published": 1,
            "verb": "add"
        },
        "field": "feed"
    }.to_json)
  end


  subject { Facebook::Messenger::Incoming::Feed.new(payload) }

  describe '.changes' do
    it 'returns the original payload' do
      expect(subject.change).to eq(payload)
    end
  end

  describe '.id' do
    it 'returns the message id' do
      expect(subject.id).to eq(payload['value']['post_id'])
    end
  end

end
