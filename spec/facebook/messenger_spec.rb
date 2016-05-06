require 'spec_helper'

describe Facebook::Messenger do
  describe '#configure' do
    before do
      subject.configure.access_token = 'token'
      subject.configure.verify_token = 'password'
    end

    context 'when a block is given' do
      it 'yields the provided access_token and verify_token' do
        allow(subject).to receive(:configure).and_yield('token', 'password')

        access_token = verify_token = nil
        subject.configure do |token, password|
          access_token = token
          verify_token = password
        end

        expect(access_token).to eq('token')
        expect(verify_token).to eq('password')
      end
    end

    context 'when called directly' do
      it 'sets correct configuration' do
        expect(subject::Configuration.access_token).to eql('token')
        expect(subject::Configuration.verify_token).to eq('password')
      end
    end
  end
end
