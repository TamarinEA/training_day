# encoding: UTF-8
require 'open-uri'
require 'nokogiri'

$store_url = 'http://www.piknikvdom.ru'
$file_name = 'catalog.txt'
$image_dirrectory = 'product_image/'
$product_count = 1000

def search_groups_urls
  html = open($store_url + '/products')
  doc = Nokogiri::HTML(html)
  all_groups = {}

  doc.css('.section').each do |section|
    group = section.css('.h3 a').text
    all_groups[group] = []
    section.css('.categories-wrap a').each do |category|
      all_groups[group] << [category['href'], category.text]
    end
  end

  all_groups
end

def seach_products_urls(group_url)
  url_products = $store_url + group_url.split('#')[0]
  group_products = []
  page = 1

  loop do
    new_url_products = url_products + '?page=' + page.to_s
    html_products = open(new_url_products)
    doc_products = Nokogiri::HTML(html_products)
    doc_products.css('.product-card-description a').each do |container|
      group_products << container['href']
    end

    unless doc_products.css('.pager-next.gray').empty?
      page += 1
    else
      break
    end
  end

  group_products.uniq
end

def product_card(product_url)
  product_card_url = $store_url + product_url.split('#')[0]
  html_product_card = open(product_card_url)
  doc_product_card = Nokogiri::HTML(html_product_card)
  [doc_product_card.css('.product-full-card h1').text.strip, doc_product_card.css('.product-image div')[0]['href']]
end

def products_in_file
  products = {}
  group_prod_num = Hash.new(0)
  id = 0
  File.foreach($file_name){ |line|
    splited = line.split("\t")
    unless splited[0] == 'id'
      id = splited[0].to_i if id < splited[0].to_i
      if products[splited[4]].nil?
        products[splited[4]] = [splited[1], splited[2], splited[3], splited[5], splited[0]]
      else
        products[splited[4]] += [splited[1], splited[2], splited[3], splited[5], splited[0]]
      end
      group_prod_num[splited[1]] += 1
    end
  }
  [products, id, group_prod_num]
end

def search_with_key(elems, array)
  n = 5
  k = array.size / n
  k.times do |i|
    if array[(i-1)*n] == elems[0] && array[(i - 1) * n + 1] == elems[1]
      return true
    end
  end
  false
end

class Image_stat
  def initialize
    @sum_size = 0
    @img_num = 0
    @max_size = 0
    @max_name = ''
    @min_size = 0
    @min_name = ''
  end

  def calculate_stat(file, product_name)
    size = File.size(file)
    @sum_size += size
    @img_num += 1
    if @max_size < size
      @max_size = size
      @max_name = product_name
    end
    if @min_size == 0 || @min_size > size
      @min_size = size
      @min_name = product_name
    end
  end

  def get_stat
    puts 'Download ' + @img_num.to_s + ' images.'
    unless @img_num == 0
      puts 'Average image size: ' + ((@sum_size.to_f / 1024) / @img_num).to_s + ' Kb.'
      puts 'Max image size: ' + (@max_size.to_f / 1024).to_s + ' Kb, ' + @max_name + '.'
      puts 'Min image size: ' + (@min_size.to_f / 1024).to_s + ' Kb, ' + @min_name + '.'
    end

  end
end

def seach_new_products(number)
  old_products, my_id, old_group_prod = products_in_file
  new_group_prod = Hash.new(0)
  all_group_prod = Hash.new(0)
  new_products = []
  new_number = 0
  image_stat = Image_stat.new
  image_number = 0

  groups = search_groups_urls

  catch(:done) do
    groups.keys.each do |group|
      groups[group].each do |sub|

        subgroup = sub[1]
        subgroup_url = sub[0]
        products = seach_products_urls(subgroup_url)
        all_group_prod[group] += products.size

        if new_number < number
          products.each do |prod|
            product_id =  prod.split(/[_#]/)[-2]

            if old_products[product_id].nil?
              product_data = product_card(prod)
              product_image = ""

              unless product_data[1].nil?
                product_image = product_data[1].split('/')[2..-1]*'_'
                image_number += 1

                unless File.exist?($image_dirrectory + product_image)
                  File.open($image_dirrectory + product_image, 'wb') do |fo|
                    fo.write open($store_url + product_data[1]).read
                  end
                  image_stat.calculate_stat($image_dirrectory + product_image, product_data[0])
                end
              end

              my_id += 1
              new_group_prod[group] += 1
              new_products << [my_id, group, subgroup, product_data[0], product_id, product_image]
              new_number += 1
              #puts new_number.to_s + ' ' + my_id.to_s

            else
              unless search_with_key([group, subgroup], old_products[product_id])
                my_id += 1
                new_number += 1
                new_group_prod[group] += 1
                image_number += 1 if old_products[product_id][3].size == 1
                new_products << [my_id, group, subgroup, old_products[product_id][2], product_id, old_products[product_id][3]]
              end
            end

            break if new_number >= number
          end
        end
      end
      throw :done unless new_number < number
    end
  end

  File.open($file_name, 'a'){ |file|
    new_products.each do |prod|
      file.puts prod*"\t"
    end
  }
  all_group_prod.keys.each do |key|
    puts 'Group: ' + key + '. In catalog: ' + all_group_prod[key].to_s + '. New produtcs: ' +
      new_group_prod[key].to_s + ', in file: ' + old_group_prod[key].to_s +
      ', ' + ((new_group_prod[key] + old_group_prod[key]) * 100 / all_group_prod[key]).to_s + '%.'
  end
  puts (image_number * 100 / new_number).to_s + '% products has image.'
  image_stat.get_stat
  return new_group_prod.keys
end

Dir.mkdir($image_dirrectory) unless File.exists?($image_dirrectory)
unless File.exists?($file_name) && File.size($file_name) > 1
  File.open($file_name, 'w') {|file| file.puts("id\tgroup\tsubgroup\tproduct_name\t" + $store_url + "_id\timage_name")}
end

new_group = []
while new_group.size < 2
  new_group << seach_new_products($product_count)
  new_group.flatten!.uniq!
end