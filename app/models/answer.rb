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

  # метод возвращает шестизначное число, добавляя недостающие цифры
  def corrector(param_num)
    param_num.insert(0, 0) until param_num.length >= 6
    param_num # возвращаем число в виде массива
  end

  def process
    @result = Enumerator.new do |element| # list - объект класса Enumerator
      iter = 0
      n = @input.to_i
      (0..n).cycle(1) do |num| # метод примеси Enumerable
        iter += 1
        # передаём в метод число в виде массива цифр и получаем массив цифр
        number = corrector(num.digits.reverse)
        element << [iter, num] if number.take(3).sum == number.reverse.take(3).sum
      end
    end
  end
end
