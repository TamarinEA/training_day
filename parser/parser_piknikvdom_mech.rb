# encoding: UTF-8
require 'mechanize'

$store_url = 'http://www.piknikvdom.ru'
$file_name = 'catalog.txt'
$image_dirrectory = 'product_image/'
$product_count = 1000

def products_in_file
  products = {}
  group_prod_num = Hash.new(0)
  id = 0
  File.foreach($file_name){ |line|
    splited = line.split("\t")
    unless splited[0] == 'id'
      id = splited[0].to_i if id < splited[0].to_i
      products[splited[4]].nil? ?
          products[splited[4]] = [splited[1], splited[2], splited[3], splited[5], splited[0]] :
          products[splited[4]] += [splited[1], splited[2], splited[3], splited[5], splited[0]]
      group_prod_num[splited[1]] += 1
    end
  }
  [products, id, group_prod_num]
end

def search_with_key(elems, array)
  n = 5
  k = array.size / n
  k.times { |i|
    return true if array[(i-1)*n] == elems[0] && array[(i - 1) * n + 1] == elems[1]
  }
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
  loaded_number = number
  old_products, my_id, old_group_prod = products_in_file
  new_group_prod = Hash.new(0)
  all_group_prod = Hash.new(0)
  new_products = []
  new_number = 0
  image_stat = Image_stat.new
  image_number = 0

  agent = Mechanize.new
  page  = agent.get($store_url + '/products')
  groups_link = page.links_with(href: %r{^/products/[\w-]+#list})
  groups_link.reject! { |a| a.text.strip==""}
  groups_link.each { |group_link|
    group = group_link.text
    group_page = group_link.click
    subgroup_container = group_page.search('.product-category-container.section')
    subgroup_container.each { |container|
      (container.css('.product-card-container').size >= 4) ?
          all_group_prod[group] += 4 :
          all_group_prod[group] += container.css('.product-card-container').size
    }
    other_prod_on_page = group_page.search('.product-category-container.section span.arial')
    other_prod_on_page.each{ |link| all_group_prod[group] += link.text.to_i}
    if new_number < number
      catch (:done) do
        subgroups_link = group_page.links_with(href: %r{^/products/[\w-]+/[\w-]+})
        subgroups_link.select! { |a| a.node.parent['class'] == 'h3' }
        subgroups_link.each{ |sub_link|
          subgroup = sub_link.text
          products = agent.get($store_url + sub_link.href.split('#').first + '?count=all')
          product_card = products.links_with(href: %r{^/products/[\w-]+/[\w-]+/[\w-]+#product-card})
          product_card.reject!{|a| a.text.strip==""}
          product_card.each{ |product|
            product_id =  product.href.split(/[_#]/)[-2]

            if old_products[product_id].nil?
              get_product = product.click
              product_image = ""
              image = get_product.search('.product-image div').first
              product_name = get_product.search('h1').text.strip

              unless image['href'].nil?
                product_image = image['href'].split('/')[2..-1]*'_'
                image_number += 1

                unless File.exist?($image_dirrectory + product_image)
                  agent.get($store_url + image['href']).save ($image_dirrectory + product_image)
                  image_stat.calculate_stat($image_dirrectory + product_image, product_name)
                end
              end

              my_id += 1
              new_group_prod[group] += 1
              new_products << [my_id, group, subgroup, product_name, product_id, product_image]
              new_number += 1

            else
              unless search_with_key([group, subgroup], old_products[product_id])
                my_id += 1
                new_number += 1
                new_group_prod[group] += 1
                image_number += 1 if old_products[product_id][3].size == 1
                new_products << [my_id, group, subgroup, old_products[product_id][2], product_id, old_products[product_id][3]]
              end
            end

            if new_number >= number
              throw :done if (new_group_prod.size > 1)
              number += loaded_number
              all_group_prod.keys.each { |key|
                puts 'Group: ' + key + '. In catalog: ' + all_group_prod[key].to_s + '. New produtcs: ' +
                         new_group_prod[key].to_s + ', in file: ' + old_group_prod[key].to_s +
                         ', ' + ((new_group_prod[key] + old_group_prod[key]) * 100 / all_group_prod[key]).to_s + '%.'
              }
              puts (image_number * 100 / new_number).to_s + '% products has image.'
              image_stat.get_stat
            end
          }
        }
      end
    end
  }

  File.open($file_name, 'a'){ |file|
    new_products.each do |prod|
      file.puts prod*"\t"
    end
  }
  all_group_prod.keys.each { |key|
    puts 'Group: ' + key + '. In catalog: ' + all_group_prod[key].to_s + '. New produtcs: ' +
             new_group_prod[key].to_s + ', in file: ' + old_group_prod[key].to_s +
             ', ' + ((new_group_prod[key] + old_group_prod[key]) * 100 / all_group_prod[key]).to_s + '%.'
  }
  puts (image_number * 100 / new_number).to_s + '% products has image.'
  image_stat.get_stat
end

Dir.mkdir($image_dirrectory) unless File.exists?($image_dirrectory)
unless File.exists?($file_name) && File.size($file_name) > 1
  File.open($file_name, 'w') {|file| file.puts("id\tgroup\tsubgroup\tproduct_name\t" + $store_url + "_id\timage_name")}
end

seach_new_products($product_count)