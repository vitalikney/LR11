class Answer < ApplicationRecord
  validates :input, {
    presence: { message: 'Введена пустая строка' },
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      message: 'Введён символ, отличный от цифры'
    }
  }

  before_create :set_params

  def decode_output
    ActiveSupport::JSON.decode(output)
  end

  private

  def set_params
    @input = self.input.to_i
    self.output = encode_output
  end

  def encode_output
    ActiveSupport::JSON.encode(process)
  end

  def palindrome?(n)
    return true if n == n.reverse
    return false
  end

  def process
    @result = Enumerator.new do |element| # @result - объект класса Enumerator
      n = @input.to_i
      (0..n).cycle(1) do |x| # метод примеси Enumerable
        element << [x, x*x] if palindrome?(x.to_s) && palindrome?((x*x).to_s)
      end
    end
  end
end
