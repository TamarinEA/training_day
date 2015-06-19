class CatalogController < ApplicationController
  require 'csv'

  def index
    csv_string = CSV.generate(:row_sep => "\r\n", :col_sep => ";") do |csv|
      csv << ["product_id", "product_name", "group_id"]
      rows = get_catalog
      rows.each do |row|
        csv << [row['id'], row['name'], row['group_id']]
      end
    end
    send_data(csv_string, :filename => "Catalog.csv")
  end

  private
    def get_catalog
      Product.select("*")
    end
end
