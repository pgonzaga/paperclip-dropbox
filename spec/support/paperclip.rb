require "paperclip"
require_relative "credentials"

Paperclip.options[:log] = false
Paperclip::Attachment.default_options.merge!(
  storage: :dropbox,
)

module Paperclip
  class Noop < Processor
    def make
      file
    end
  end
end
