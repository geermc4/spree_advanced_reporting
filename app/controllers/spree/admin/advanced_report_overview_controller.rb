class Spree::Admin::AdvancedReportOverviewController < Spree::Admin::BaseController
  def index
    @reports = Spree::Admin::ReportsController::ADVANCED_REPORTS
    @products = Spree::Product.all
    @taxons = Spree::Taxon.all
    if defined?(MultiDomainExtension)
      @stores = Store.all
    end
    @report = Spree::AdvancedReport::IncrementReport::Revenue.new({ :search => {} })
    @top_products_report = Spree::AdvancedReport::TopReport::TopProducts.new({ :search => {} }, 5)
    @top_customers_report = Spree::AdvancedReport::TopReport::TopCustomers.new({ :search => {} }, 5)
    @top_customers_report.ruportdata.remove_column(I18n.t("adv_report.units"))

    # From overview_dashboard, Cleanup eventually
    orders = Spree::Order.find(:all, :order => "completed_at DESC", :limit => 10, :include => {:line_items => {:product => :taxons}}, :conditions => "completed_at IS NOT NULL")
    @last_orders = orders.inject([]) { |arr, o| arr << [o.bill_address.firstname, o.line_items.sum(:quantity), o.total, o.number]; arr }
  end
end
