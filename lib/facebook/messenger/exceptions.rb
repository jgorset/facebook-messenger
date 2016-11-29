module Facebook
  module Messenger
    # Base Facebook Messenger exception.
    class Error < StandardError
      attr_reader :message
      attr_reader :type
      attr_reader :code
      attr_reader :subcode
      attr_reader :fbtrace_id

      def initialize(message = nil, type = nil, code = nil,
                     subcode = nil, fbtrace_id = nil)
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

    class AccessTokenError < Error; end
    class AccountLinkingError < Error; end
    class BadParameterError < Error; end
    class InternalError < Error; end
    class LimitError < Error; end
    class PermissionError < Error; end

    # Parses and raises Facebook response errors for the send API.
    class ErrorParser
      INTERNAL_ERROR_CODES = {
        1200 => []
      }.freeze

      LIMIT_ERROR_CODES = {
        4 => [2_018_022],
        100 => [2_018_109]
      }.freeze

      BAD_PARAMETER_ERROR_CODES = {
        100 => [2_018_001, nil]
      }.freeze

      ACCESS_TOKEN_ERROR_CODES = {
        190 => []
      }.freeze

      PERMISSION_ERROR_CODES = {
        10 => [2_018_065, 2_018_108],
        200 => [2_018_108, 2_018_028, 2_018_027, 2_018_021]
      }.freeze

      ACCOUNT_LINKING_ERROR_CODES = {
        10_303 => []
      }.freeze

      class << self
        # Raise any errors in the given response.
        #
        # response - A HTTParty::Response object.
        #
        # Returns nil if no errors were found, otherwises raises appropriately.
        def raise_errors_from(response)
          return unless response.key? 'error'

          error = response['error']
          args = error_args(error)

          error_code = error['code']
          error_subcode = error['error_subcode']

          raise_code_only_error(error_code, args) if error_subcode.nil?

          raise_code_subcode_error(error_code, error_subcode, args)

          # Default to unidentified error
          raise Error, error_args(error)
        end

        private

        def raise_code_only_error(error_code, args)
          raise InternalError, args       if internal_error?(error_code)
          raise AccessTokenError, args    if access_token_error?(error_code)
          raise AccountLinkingError, args if account_linking_error?(error_code)
        end

        def raise_code_subcode_error(error_code, error_subcode, args)
          raise LimitError, args        if limit_error?(error_code,
                                                        error_subcode)
          raise BadParameterError, args if bad_parameter_error?(error_code,
                                                                error_subcode)
          raise PermissionError, args   if permission_error?(error_code,
                                                             error_subcode)
        end

        def internal_error?(error_code)
          INTERNAL_ERROR_CODES.keys.include? error_code
        end

        def access_token_error?(error_code)
          ACCESS_TOKEN_ERROR_CODES.keys.include? error_code
        end

        def account_linking_error?(error_code)
          ACCOUNT_LINKING_ERROR_CODES.keys.include? error_code
        end

        def limit_error?(error_code, error_subcode)
          limit_errors = LIMIT_ERROR_CODES[error_code]
          return unless limit_errors

          limit_errors.include? error_subcode
        end

        def bad_parameter_error?(error_code, error_subcode)
          bad_parameter_errors = BAD_PARAMETER_ERROR_CODES[error_code]
          return unless bad_parameter_errors

          bad_parameter_errors.include? error_subcode
        end

        def permission_error?(error_code, error_subcode)
          permission_errors = PERMISSION_ERROR_CODES[error_code]
          return unless permission_errors

          permission_errors.include? error_subcode
        end

        def error_args(error)
          [
            error['message'], error['type'], error['code'],
            error['error_subcode'], error['fbtrace_id']
          ]
        end
      end
    end
  end
end
