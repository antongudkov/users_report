RSpec.describe UsersReport::Report do
  subject { described_class.new('spec/fixtures/data.txt') }

  describe '#parse_row' do
    context 'with user' do
      let(:row) { load_fixture('user').shift }

      it 'sets current user' do
        subject.parse_row(row)
        expect(subject.current_user).to be_instance_of(UsersReport::User)
      end

      it 'adds user to users list' do
        subject.parse_row(row)
        expect { subject.parse_row(row) }.to change { subject.users.count }.by(1)
      end
    end

    context 'with session' do
      let(:row) { load_fixture('sessions').shift }

      before do
        user_row = load_fixture('user').shift
        subject.parse_row(user_row)
      end

      it 'adds session to current user' do
        expect { subject.parse_row(row) }.to change { subject.current_user.sessions.count }.by(1)
      end
    end
  end

  describe '#parse_user' do
    let(:row) { load_fixture('user').shift }

    let(:expected_result) do
      {
        id: row[1],
        first_name: row[2],
        last_name: row[3],
        age: row[4]
      }
    end

    it { expect(subject.parse_user(row)).to eq(expected_result) }
  end

  describe '#parse_session' do
    let(:row) { load_fixture('sessions').shift }

    let(:expected_result) do
      {
        user_id: row[1],
        session_id: row[2],
        browser: row[3],
        time: row[4],
        date: row[5]
      }
    end

    it { expect(subject.parse_session(row)).to eq(expected_result) }
  end

  describe '#generate' do
    let(:expected_result) { load_result }

    it 'generates report' do
      subject.generate!
      expect(subject.report).to eq(expected_result)
    end
  end
end