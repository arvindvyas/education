# spec/mailers/application_mailer_spec.rb
require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  it 'inherits from ActionMailer::Base' do
    expect(described_class).to be < ActionMailer::Base
  end

  it 'uses the default "from" address' do
    expect(described_class.default[:from]).to eq('from@example.com')
  end

end
