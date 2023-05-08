namespace :products do
  desc 'Assign all old products to a particular category'
  
  task :assign_to_category, [:category_name] => :environment do
    category_id = Category.find_by_name args.category_name

    Product.find_each do |product|
      product.update(category_id: category_id) unless product.category_id

      puts "Product with id: #{product.id} updated"
    end
  end
end
