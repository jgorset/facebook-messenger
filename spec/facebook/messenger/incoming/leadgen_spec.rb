require 'spec_helper'

describe Facebook::Messenger::Incoming::Leadgen do
  let :payload do
     JSON.parse({
          "value": {
            "created_time": 1683790226,
            "leadgen_id": "798522598540294",
            "page_id": "119324881085321",
            "form_id": "172197529124035"
          },
          "field": "leadgen"
    }.to_json)
  end

  subject { Facebook::Messenger::Incoming::Leadgen.new(payload) }

  describe '.changes' do
    it 'returns the original payload' do
      expect(subject.change).to eq(payload)
    end
  end

  describe '.id' do
    it 'returns the message id' do
      expect(subject.id).to eq(payload['value']['leadgen_id'])
    end
  end

end
