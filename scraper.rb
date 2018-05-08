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
      marketcap = element.search(".market-cap").text.strip
      price = element.search(".price").text.strip.gsub(/[^\d\.]/, '').to_f
      volume = element.search(".volume").text.strip.gsub(/[^\d\.]/, '').to_f
      cirulating_supply = element.search(".circulating-supply").text.strip.gsub(/[^\d\.]/, '').to_f
      result_coins << {name: name, marketcap: marketcap, price: price, volume: volume, cirulating_supply: cirulating_supply}
      # byebug
    end
  end
  return result_coins
end

p fetch_urls

#   html_file = open(url).read
#   html_doc = Nokogiri::HTML(html_file)
#   result = []

#   title = html_doc.search("h1").text.strip
#   title = title[0..title.length-8]
#   year = html_doc.search("h1 a").text.strip
#   # itle = html_doc.search("h1").text.match
#   summary = html_doc.search(".summary_text").text.strip
#   director = html_doc.search('span[itemprop="director"]').text.strip
#   actors = html_doc.search('span[itemprop="actors"]')
#   cast = []
#   actors.each do |actor|
#     cast << actor.text.strip.split(",").first
#   end

#   hash = {
#     title: title,
#     year: year,
#     storyline: summary,
#     director: director,
#     cast: cast
#   }

#   p hash

# end

# get_movie_info("https://www.imdb.com/title/tt0111161/")
