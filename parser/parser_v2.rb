# encoding: UTF-8
require 'open-uri'
require 'nokogiri'

$store_url = 'http://www.piknikvdom.ru'
$file_name = 'catalog1.txt'

def search_groups_urls
  html = open($store_url + '/products')
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

def products_in_file
  products = {}
  File.foreach($file_name){ |line|
    splited = line.split("\t")
    if products[splited[3]].nil?
      products[splited[3]] = [splited[0], splited[1], splited[2], splited[4]]
    else
      products[splited[3]] += [splited[0], splited[1], splited[2], splited[4]]
    end
  }
  products
end

def search_with_key(elems, array)
  k = array.size / 4
  k.times do |i|
    if array[(i-1)*4] == elems[0] && array[(i - 1) * 4 + 1] == elems[1]
      return true
    end
  end
  false
end

def seach_new_products(number)
  old_products = products_in_file
  new_products = {}
  new_number = 0

  catch(:done) do
    groups = search_groups_urls

    groups.keys.each do |group|

      groups[group].each do |sub|
        subgroup = sub[1]
        subgroup_url = sub[0]
        products = seach_products_urls(subgroup_url)

        products.each do |prod|
          product_id =  prod.split(/[_#]/)[-2]

          if old_products[product_id].nil?
            product_data = product_card(prod)
            product_image = ""

            unless product_data[1].nil?
              product_image = product_data[1].split('/')[2..-1]*'_'

              unless File.exist?('product_image/' + product_image)
                File.open('product_image/' + product_image, 'wb') do |fo|
                  fo.write open($store_url + product_data[1]).read
                end
              end
            end

            new_products[product_id] = [group, subgroup, product_data[0], product_image]
            new_number += 1

          else
            unless search_with_key([group, subgroup], old_products[product_id][0])
              new_products[product_id] = [group, subgroup, old_products[product_id][2], old_products[product_id][3]]
            end
          end

          puts new_number
          throw :done if new_number >= number
        end
      end
    end
  end

  File.open($file_name, 'a'){ |file|
    new_products.keys.each do |key|
      file.puts new_products[key][0] + "\t" + new_products[key][1] + "\t" + new_products[key][2] + "\t" + key + "\t" + new_products[key][3]
    end
  }
end

seach_new_products(20)