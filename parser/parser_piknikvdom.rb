# encoding: UTF-8
require 'open-uri'
require 'nokogiri'

$store_url = 'http://www.piknikvdom.ru'
catalog_url = 'http://www.piknikvdom.ru/products'

def search_groups_urls(url)
  html = open(url)
  doc = Nokogiri::HTML(html)
  all_groups = {}

  doc.css('.section').each do |section|
    group = section.css('.h3').css('a').text
    all_groups[group] = []
    section.css('.categories-wrap').css('a').each do |category|
      all_groups[group] << [category['href'], category.text]
    end
  end

  all_groups
end

def seach_products_urls(group_url)
  url_products = $store_url + group_url.split('#')[0]
  html_products = open(url_products)
  doc_products = Nokogiri::HTML(html_products)
  group_products = []
  page = 2

  loop do
    doc_products.css('.product-card-description').css('a').each do |container|
      group_products << container['href']
    end

    break if doc_products.css('.pager-next.gray').empty?

    new_url_producs = url_products + '?page=' + page.to_s
    html_products = open(new_url_producs)
    doc_products = Nokogiri::HTML(html_products)
    page += 1
  end

  group_products
end

def product_card(product_url)
  product_card_url = $store_url + product_url.split('#')[0]
  html_product_card = open(product_card_url)
  doc_product_card = Nokogiri::HTML(html_product_card)
  [doc_product_card.css('.product-full-card h1').text.strip, doc_product_card.css('.product-image div')[0]['href']]
end

=begin
groups = search_groups_urls(catalog_url)
group = groups.keys[0]
subgroup = groups[group][0][1]
subgroup_url = groups[group][0][0]
products = seach_products_urls(subgroup_url)
=end
file_text = []

groups = search_groups_urls(catalog_url)
groups.keys.each do |group|
  puts group
  groups[group].each do |sub|
    subgroup = sub[1]
    subgroup_url = sub[0]
    puts subgroup
    products = seach_products_urls(subgroup_url)
    products.each do |prod|
      product_id =  prod.split(/[_#]/)[-2]
      product_data = product_card(prod)
      product_image = ""
      unless product_data[1].nil?
        product_image = product_data[1].split('/')[2..-1]*'_'
        #File.open('product_image/' + product_image, 'wb') do |fo|
        #  fo.write open($store_url + product_data[1]).read
        #end
      end
      file_text << group + "\t" + subgroup + "\t" + product_data[0] + "\t" + product_id + "\t" + product_image
    end
  end
end


File.open('catalog.txt', 'w'){ |file|
  file_text.each do |line|
    file.puts line
  end
}