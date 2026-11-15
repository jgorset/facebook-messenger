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

  describe '.page_id' do
    it 'returns nil when the change has no entry' do
      expect(subject.page_id).to be_nil
    end
  end

  context 'with a comment change' do
    let :payload do
      JSON.parse({
        value: {
          from: { id: '24018572657841976', name: 'Jane Doe' },
          message: 'How much does it cost?',
          post_id: '399731066566356_1234567890',
          comment_id: '1234567890_987654321',
          parent_id: '399731066566356_1234567890',
          created_time: 1_762_423_200,
          item: 'comment',
          verb: 'add'
        },
        field: 'feed',
        entry: { id: '399731066566356', time: 1_762_423_201 }
      }.to_json)
    end

    it 'returns the page id from the entry' do
      expect(subject.page_id).to eq('399731066566356')
    end

    it 'returns the comment fields' do
      expect(subject.verb).to eq('add')
      expect(subject.post_id).to eq('399731066566356_1234567890')
      expect(subject.comment_id).to eq('1234567890_987654321')
      expect(subject.parent_id).to eq('399731066566356_1234567890')
      expect(subject.from).to eq('id' => '24018572657841976',
                                 'name' => 'Jane Doe')
    end
  end
end
