# spec/channels/application_cable/channel_spec.rb
require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  it 'inherits from ActionCable::Connection::Base' do
    expect(described_class).to be < ActionCable::Connection::Base
  end
end