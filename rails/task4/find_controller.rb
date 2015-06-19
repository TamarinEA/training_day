#!/bin/env ruby
# encoding: utf-8

class FindController < ApplicationController

  def milk
    sql = <<-SQL
      SELECT g.name FROM groups g, (
             SELECT group_id, COUNT(id) as prod_count
             FROM products
             WHERE name LIKE "%Молоко%"
             GROUP BY group_id
             ) p
      WHERE g.id = p.group_id
      ORDER BY p.prod_count DESC
    SQL
    @groups = ActiveRecord::Base.connection.select_all(sql)
  end

  def index
    @groups = Product.select("groups.name, COUNT(products.id) as prod_count")
                .where("products.name LIKE '%Молоко%'")
                .group("group_id")
                .joins(:group)
                .order("prod_count DESC")
  end
end
