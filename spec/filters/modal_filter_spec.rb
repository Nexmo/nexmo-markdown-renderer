require 'spec_helper'

RSpec.describe Nexmo::Markdown::ModalFilter do
  before(:each) do
    allow(Nexmo::Markdown::Config).to receive(:docs_base_path).and_return('.')
  end
  it 'takes input of title and markdown link and produces HTML content' do
    allow(SecureRandom).to receive(:hex).and_return('12345')
    input = '@[Possible values](spec/filters/fixtures/modals/api/developer/message/search/response/final-status.md)'

    expected_output = "<a href='javascript:void(0)' data-modal='M12345' class='Vlt-modal-trigger Vlt-text-link'>Possible values</a>FREEZESTARTPGRpdiBjbGFzcz0iVmx0LW1vZGFsIiBpZD0iTTEyMzQ1Ij4KICA8ZGl2IGNsYXNzPSJWbHQtbW9kYWxfX3BhbmVsIj4KICAgIDxkaXYgY2xhc3M9IlZsdC1tb2RhbF9fY29udGVudCI-CiAgPGRpdiBjbGFzcz0iVmx0LXRhYmxlIFZsdC10YWJsZS0tYm9yZGVyZWQiPjx0YWJsZT4KPHRoZWFkPgo8dHI-Cjx0aD5WYWx1ZTwvdGg-Cjx0aD5EZXNjcmlwdGlvbjwvdGg-CjwvdHI-CjwvdGhlYWQ-Cjx0Ym9keT4KPHRyPgo8dGQ-PGNvZGU-REVMSVZSRDwvY29kZT48L3RkPgo8dGQ-VGhpcyBtZXNzYWdlIGhhcyBiZWVuIGRlbGl2ZXJlZCB0byB0aGUgcGhvbmUgbnVtYmVyLjwvdGQ-CjwvdHI-Cjx0cj4KPHRkPjxjb2RlPkVYUElSRUQ8L2NvZGU-PC90ZD4KPHRkPlRoZSB0YXJnZXQgY2FycmllciBkaWQgbm90IHNlbmQgYSBzdGF0dXMgaW4gdGhlIDQ4IGhvdXJzIGFmdGVyIHRoaXMgbWVzc2FnZSB3YXMgZGVsaXZlcmVkIHRvIHRoZW0uPC90ZD4KPC90cj4KPHRyPgo8dGQ-PGNvZGU-VU5ERUxJVjwvY29kZT48L3RkPgo8dGQ-VGhlIHRhcmdldCBjYXJyaWVyIGZhaWxlZCB0byBkZWxpdmVyIHRoaXMgbWVzc2FnZS48L3RkPgo8L3RyPgo8dHI-Cjx0ZD48Y29kZT5SRUpFQ1REPC9jb2RlPjwvdGQ-Cjx0ZD5UaGUgdGFyZ2V0IGNhcnJpZXIgcmVqZWN0ZWQgdGhpcyBtZXNzYWdlLjwvdGQ-CjwvdHI-Cjx0cj4KPHRkPjxjb2RlPlVOS05PV048L2NvZGU-PC90ZD4KPHRkPlRoZSB0YXJnZXQgY2FycmllciBoYXMgcmV0dXJuZWQgYW4gdW5kb2N1bWVudGVkIHN0YXR1cyBjb2RlLjwvdGQ-CjwvdHI-CjwvdGJvZHk-CjwvdGFibGU-PC9kaXY-CiAgICA8L2Rpdj4KICA8L2Rpdj4KPC9kaXY-Cg==FREEZEEND"

    expect(described_class.call(input)).to eq(expected_output)
  end

  it 'does not transform text that does not match the regex' do
    input = 'some text'

    expected_output = 'some text'

    expect(described_class.call(input)).to eql(expected_output)
  end

  it 'does not transform an argument of only a whitespace' do
    input = ' '

    expected_output = ' '

    expect(described_class.call(input)).to eql(expected_output)
  end
end
