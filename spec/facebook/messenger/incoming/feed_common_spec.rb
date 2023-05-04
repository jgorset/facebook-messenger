require 'spec_helper'

class Dummy2
  include Facebook::Messenger::Incoming::FeedCommon
end

payload = JSON.parse({
  "value": {
    "from": {
      "id": "100518329516574",
      "name": "Vit Service"
    },
    "message": "post 7",
    "post_id": "100518329516574_193994006819374",
    "created_time": 1682932701,
    "item": "status",
    "published": 1,
    "verb": "add"
  },
  "field": "feed"
}.to_json)

describe Dummy2 do
  subject { Dummy2.new(payload) }

  describe '.item' do
    it 'returns the item' do
      expect(subject.item).to eq(payload['item'])
    end
  end

end
