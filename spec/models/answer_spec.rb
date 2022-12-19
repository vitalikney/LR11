require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'If adding with similar params' do
    before do
      Answer.create!(input: 23) if Answer.find_by(input: 23).nil?
    end
    it 'should return error if value isn`t unique' do
      expect { Answer.create!(input: 23) }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    context 'should return correct result' do
      before do
        Answer.delete_by(input: 1002)
      end
      it 'when input 1002' do
        expect(Answer.create!(input: 1002).decode_output).to eq([[1, 0], [1002, 1001]])
      end
    end

    context 'check existance' do
      it 'exists in database' do
        expect(Answer.find_by(input: 23).nil?).to eq(false)
      end
    end
  end
end
