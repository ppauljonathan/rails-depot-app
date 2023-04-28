desc 'Assign all old products to Category 1'

task port_legacy_products: :environment do
  Product.find_each do |product|
    product.update(category_id: 1) unless product.category_id
  end
end