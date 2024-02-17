# spec/jobs/application_job_spec.rb
require 'rails_helper'

RSpec.describe ApplicationJob do
  it 'inherits from ActiveJob::Base' do
    expect(described_class).to be < ActiveJob::Base
  end
end
