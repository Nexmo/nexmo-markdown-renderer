require 'rails_helper'

RSpec.describe Nexmo::Markdown::TooltipFilter do
  it 'returns whitespace with whitespace input' do
    input = ' '

    expected_output = ' '

    expect(described_class.call(input)).to eql(expected_output)
  end

  it 'returns unaltered non-matching input' do
    input = 'some text'

    expected_output = 'some text'

    expect(described_class.call(input)).to eql(expected_output)
  end

  it 'returns unaltered matching but missing details input' do
    input = '^[]()'

    expected_output = '^[]()'

    expect(described_class.call(input)).to eql(expected_output)
  end

  it 'returns encoded text with matching input' do
    input = '^[more](Here is a tooltip.)'

    expected_output = 'FREEZESTARTPHNwYW4gY2xhc3M9IlZsdC10b29sdGlwIFZsdC10b29sdGlwLS10b3AiIHRpdGxlPSJIZXJlIGlzIGEgdG9vbHRpcC4iIHRhYmluZGV4PSIwIj4KICBtb3JlJm5ic3A7CiAgPHN2ZyBjbGFzcz0iVmx0LWljb24gVmx0LWljb24tLXNtYWxsZXIgVmx0LWljb24tLXRleHQtYm90dG9tIFZsdC1ibHVlIiBhcmlhLWhpZGRlbj0idHJ1ZSI-PHVzZSB4bGluazpocmVmPSIvc3ltYm9sL3ZvbHRhLWljb25zLnN2ZyNWbHQtaWNvbi1oZWxwLW5lZ2F0aXZlIi8-PC9zdmc-Cjwvc3Bhbj4KFREEZEEND'

    expect(described_class.call(input)).to eql(expected_output)
  end
end
