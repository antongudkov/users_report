RSpec.describe UsersReport::User do
  let(:session) { UsersReport::Session.new(load_session) }

  subject { described_class.new(load_user) }

  describe 'attributes' do
    it 'has id' do
      expect(subject.id).to eq(1)
    end

    it 'has first name' do
      expect(subject.first_name).to eq('Leida')
    end

    it 'has last name' do
      expect(subject.last_name).to eq('Cira')
    end

    it 'has age' do
      expect(subject.age).to eq(30)
    end

    it 'has sessions' do
      expect(subject.sessions).to eq([])
    end
  end

  describe '#user_key' do
    it { expect(subject.user_key).to eq('Leida Cira') }
  end

  describe '#add_session' do
    it 'adds session to user sessions list' do
      subject.add_session(session)

      expect(subject.sessions.last).to eq(session)
    end
  end

  describe '#browsers' do
    before do
      2.times { subject.add_session(session) }
    end

    it 'returns sessions browsers' do
      expect(subject.browsers).to eq([session.browser, session.browser])
    end
  end

  describe '#sessions_times' do
    before do
      2.times { subject.add_session(session) }
    end

    it 'returns sessions times' do
      expect(subject.sessions_times).to eq([session.time, session.time])
    end
  end

  describe '#used_ie?' do
    context 'with session having IE' do
      before do
        allow(session).to receive(:browser) { 'Internet Explorer 28'.upcase }
        subject.add_session(session)
      end

      it { expect(subject.used_ie?).to be_truthy }
    end

    context 'with session not having IE' do
      before do
        allow(session).to receive(:browser) { 'Safari 29'.upcase }
        subject.add_session(session)
      end

      it { expect(subject.used_ie?).to be_falsey }
    end
  end

  describe '#always_used_chrome?' do
    let(:session_2) { UsersReport::Session.new(load_session) }

    context 'with all sessions having Chrome' do
      before do
        allow(session).to receive(:browser) { 'Chrome 6'.upcase }
        allow(session_2).to receive(:browser) { 'Chrome 35'.upcase }
        subject.add_session(session)
        subject.add_session(session_2)
      end

      it { expect(subject.always_used_chrome?).to be_truthy }
    end

    context 'with any session not having Chrome' do
      before do
        allow(session).to receive(:browser) { 'Chrome 6'.upcase }
        allow(session_2).to receive(:browser) { 'Safari 29'.upcase }
        subject.add_session(session)
        subject.add_session(session_2)
      end

      it { expect(subject.always_used_chrome?).to be_falsey }
    end
  end

  describe '#as_json' do
    let(:sessions) { load_sessions }
    
    let(:expected_result) do
      {
        'sessionsCount' => 6,
        'totalTime' => '455 min.',
        'longestSession' => '118 min.',
        'browsers' => 'FIREFOX 12, INTERNET EXPLORER 28, INTERNET EXPLORER 28, INTERNET EXPLORER 35, SAFARI 29, SAFARI 39',
        'usedIE' => true,
        'alwaysUsedChrome' => false,
        'dates' => ['2017-09-27', '2017-03-28', '2017-02-27', '2016-10-23', '2016-09-15', '2016-09-01']
      }
    end

    before do
      sessions.each do |s|
        session = UsersReport::Session.new(s)
        subject.add_session(session)
      end
    end

    it { expect(subject.as_json).to eq(expected_result) }
  end
end