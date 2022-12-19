require 'rails_helper'

RSpec.describe "Calc", type: :request do
  describe "GET /" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /view" do
    it "returns http status 200" do
      get "/calc/view", params:{number: '1010'}
      expect(response).to have_http_status(200)
    end

    it "input empty string" do
      get "/calc/view", params:{number: ''}
      expect(response).to have_http_status(302)
    end

    it "has no parameters" do
      get "/calc/view"
      expect(response).to have_http_status(302)
    end

    it "incorrect input" do
      get "/calc/view", params:{number: 'abc'}
      expect(response).to have_http_status(302)
    end
end

  context 'controller tests' do
    it 'test @result' do
      get "/calc/view", params:{number: '1002'}
      result = assigns[:result]
      expect(result[0]).to eq([1, 0])
      expect(result[1]).to eq([1002, 1001])
    end
  end

  context 'redirect to input page' do
    it "has no parametrs" do
      get "/calc/view"
      expect(response).to redirect_to(root_path)
    end

    it "has empty string" do
      get "/calc/view", params:{input_value:""}
      expect(response).to redirect_to(root_path)
    end

    it "has not number symbol" do
      get "/calc/view", params:{input_value:"qwerty"}
      expect(response).to redirect_to(root_path)
    end
  end


  context 'parse answer' do
    it 'parameter 1002' do
      get "/calc/view", params:{number: '1010'}
      html = Nokogiri::HTML(response.body) # парсинг html-страницы
      answer = [['1', '0'], ['1002', '1001']]
      td = html.search('td')
      answer.each_with_index do |data, index|
        expected = [td[2 * index].text, td[1 + 2 * index].text]
        expect(expected).to eq(data)
      end
    end
  end

end