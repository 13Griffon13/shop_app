require "httparty" 
require "nokogiri"

# defining a data structure to store the scraped data 
Retailer = Struct.new(:url, :name,)


response = HTTParty.get("https://en.wikipedia.org/wiki/Category:Online_retailers_of_the_United_States")

#puts response

# parsing the HTML document returned by the server 
document = Nokogiri::HTML(response.body)

# selecting all HTML product elements 
pages = document.css("#mw-pages")

items = pages.css("li")

itemList = []

items.each do |item| 
	# extracting the data of interest 
	# from the current product HTML element 
	url = "https://en.wikipedia.org/"+item.css("a").first.attribute("href").value 
	name = item.css("a").text
 
	# storing the scraped data in a PokemonProduct object 
	retailer = Retailer.new(url, name) 
 
	# adding the PokemonProduct to the list of scraped objects 
    itemList.push(retailer) 
end

csv_headers = ["url", "name"] 
CSV.open("output.csv", "wb", write_headers: true, headers: csv_headers) do |csv| 
	# adding each pokemon_product as a new row 
	# to the output CSV file 
	itemList.each do |item| 
		csv << item 
	end 
end

puts itemList