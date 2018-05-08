require "open-uri"
require "nokogiri"
require "pry"

BASE_URL = "https://coinmarketcap.com/"

def fetch_urls
  url = BASE_URL
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)

  coins = []
  html_doc.search(".currency-name").each do |element|
    coins << element["data-sort"]
  end

  coins_clean = []
  coins.each do |element|
    coins_clean << element.downcase.gsub(" ","-")
  end


  result_coins = []
  coins_clean.each do |coin|
    html_doc.search("#id-#{coin}").each do |element|
      name = coin
      url_field = element.search(".currency-name-container")
      url = url_field[0]["href"]
      marketcap = element.search(".market-cap").text.strip
      price = element.search(".price").text.strip.gsub(/[^\d\.]/, '').to_f
      volume = element.search(".volume").text.strip.gsub(/[^\d\.]/, '').to_f
      circulating_supply = element.search(".circulating-supply").text.strip.gsub(/[^\d\.]/, '').to_f
      result_coins << {name: name, url: url, marketcap: marketcap, price: price, volume: volume, circulating_supply: circulating_supply}
      # byebug
    end
  end
  return result_coins
end

p fetch_urls
