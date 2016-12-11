module Facebook
  module Messenger
    module Bot
      # Base Facebook Messenger exception.
      class SendError < Facebook::Messenger::Error
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

      class AccessTokenError < SendError; end
      class AccountLinkingError < SendError; end
      class BadParameterError < SendError; end
      class InternalError < SendError; end
      class LimitError < SendError; end
      class PermissionError < SendError; end
    end
  end
end
