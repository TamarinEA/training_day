require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => 'postgresql',
                                        :host => 'localhost',
                                        :username => 'postgres',
                                        :database => 'mydb');

=begin
class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
    end
  end
end

CreateProducts.new.change
=end

class Products < ActiveRecord::Base
end

product_array = []
3.times do |i|
  puts "Enter product #{i}"
  product_array << gets.chomp.split(',')
end
product_array.each{ |p| 
prod = Products.create(:name => p[0], :price => p[1])
prod.save
}
product = Products.all
product.each{ |p| puts "#{p.name} #{p.price}"}
