require 'spec_helper'

describe Facebook::Messenger do
  describe '.on' do
    describe ':message' do
      before do
        Facebook::Messenger.on :message do |sender, recipient, message|
          [sender, recipient, message]
        end
      end

      it "registers a method called 'message'" do
        expect(
          Facebook::Messenger.message('<sender>', '<recipient>', '<message>')
        ).to eq(['<sender>', '<recipient>', '<message>'])
      end
    end

    describe ':postback' do
      before do
        Facebook::Messenger.on :postback do |sender, recipient, payload|
          [sender, recipient, payload]
        end
      end

      it "registers a method called 'postback'" do
        expect(
          Facebook::Messenger.postback('<sender>', '<recipient>', '<payload>')
        ).to eq(['<sender>', '<recipient>', '<payload>'])
      end
    end
  end
end
