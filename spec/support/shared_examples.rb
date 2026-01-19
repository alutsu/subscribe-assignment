# frozen_string_literal: true

RSpec.shared_examples 'an immutable object' do
  it 'is frozen after creation' do
    expect(subject).to be_frozen
  end
end

RSpec.shared_examples 'has frozen string attribute' do |attribute_name|
  it "has a frozen #{attribute_name}" do
    expect(subject.public_send(attribute_name)).to be_frozen
  end
end
