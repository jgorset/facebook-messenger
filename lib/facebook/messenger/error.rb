module Facebook
  module Messenger
    # Base Facebook Messenger exception.
    class Error < StandardError
      attr_reader :message
      attr_reader :type
      attr_reader :code
      attr_reader :subcode
      attr_reader :fbtrace_id

      def initialize(message: nil, type: nil, code: nil,
                     subcode: nil, fbtrace_id: nil)
        @message = message
        @type = type
        @code = code
        @subcode = subcode
        @fbtrace_id = fbtrace_id
      end

      def to_s
        @message
      end
    end
  end
end
