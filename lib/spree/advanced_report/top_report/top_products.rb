class Spree::AdvancedReport::TopReport::TopProducts < Spree::AdvancedReport::TopReport
  def name
    "Top Selling Products by Revenue"
  end

  def description
    "Top selling products, calculated by revenue"
  end

  def initialize(params, limit)
    super(params)

    orders.each do |order|
      order.line_items.each do |li|
        if !li.product.nil?
          data[li.product.id] ||= {
            :name => li.product.name.to_s,
            :taxons => li.product.taxons.collect(&:name).join(", "),
            :revenue => 0,
            :units => 0
          }
          data[li.product.id][:revenue] += li.quantity*li.price 
          data[li.product.id][:units] += li.quantity
        end
      end
    end

    self.ruportdata = Table(%w[name Taxons Units Revenue])
    data.inject({}) { |h, (k, v) | h[k] = v[:revenue]; h }.sort { |a, b| a[1] <=> b [1] }.reverse[0..limit].each do |k, v|
      ruportdata << { "name" => data[k][:name], "Taxons" => data[k][:taxons], "Units" => data[k][:units], "Revenue" => data[k][:revenue] }
    end
    ruportdata.replace_column("Revenue") { |r| "$%0.2f" % r.Revenue }
    ruportdata.rename_column("name", "Product Name")
  end
end
