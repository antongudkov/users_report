RSpec.describe UsersReport::Session do
  subject { described_class.new(load_session) }

  it 'has user_id' do
    expect(subject.user_id).to eq(0)
  end

  it 'has session_id' do
    expect(subject.session_id).to eq(0)
  end

  it 'has browser' do
    expect(subject.browser).to eq('SAFARI 29')
  end

  it 'has time' do
    expect(subject.time).to eq(87)
  end

  it 'has date' do
    expect(subject.date).to eq('2016-10-23')
  end
end