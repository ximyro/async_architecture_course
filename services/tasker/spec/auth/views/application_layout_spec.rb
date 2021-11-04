require "spec_helper"

RSpec.describe Auth::Views::ApplicationLayout, type: :view do
  let(:layout)   { Auth::Views::ApplicationLayout.new({ format: :html }, "contents") }
  let(:rendered) { layout.render }

  it 'contains application name' do
    expect(rendered).to include('Auth')
  end
end
