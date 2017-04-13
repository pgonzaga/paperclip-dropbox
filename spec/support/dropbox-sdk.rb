require "dropbox"
require_relative "vcr"

class Dropbox::Client
  attr_reader :session, :root

  def self.uploaded_files
    @uploaded_files ||= []
  end

  alias normal_upload upload
  def upload(path, file, options = {})
    self.class.uploaded_files << [path, self]
    normal_upload(path, file, options)
  end

  alias normal_delete delete
  def delete(path)
    self.class.uploaded_files.delete_if { |p, _| p == path }
    normal_delete(path)
  end
end

# Delete all uploaded files if there were any
RSpec.configure do |config|
  config.after do
    Dropbox::Client.uploaded_files.each do |path, dropbox_client|
      dropbox_client.delete(path)
    end
    Dropbox::Client.uploaded_files.clear
  end
end
