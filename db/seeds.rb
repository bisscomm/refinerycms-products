::Refinery::User.all.each do |user|
  user.plugins.where(:name => 'refinery-products').first_or_create!
end if defined?(::Refinery::User)

Refinery::I18n.frontend_locales.each do |lang|
  I18n.locale = lang

  if defined?(::Refinery::Page)
    shop_page = Refinery::Page.find_by(:link_url => Refinery::Products.shop_path)

    unless shop_page
      shop_page = ::Refinery::Page.create({
        :title => "Shop",
        :link_url => Refinery::Products.shop_path,
        :menu_match => "^(/shop.*)|#{Refinery::Products.shop_path}$",
        :deletable => false
      })
      shop_page.parts.create({
        :title => "Body",
        :body => "<p>This is the shop page.</p>",
        :position => 0
      })
    end

    products_url = "#{Refinery::Products.shop_path}#{Refinery::Products.products_path}"
    unless Refinery::Page.where(:link_url => products_url).any?
      products_page = shop_page.children.create({
        :title => "Products",
        :link_url => products_url,
        :menu_match => "^(/shop/products)|#{products_url}$",
        :show_in_menu => false,
        :deletable => false
      })
      products_page.parts.create({
        :title => "Body",
        :body => "<p>This is the products page.</p>",
        :position => 0
      })
    end

    categories_url = "#{Refinery::Products.shop_path}#{Refinery::Products.products_categories_path}"
    unless Refinery::Page.where(:link_url => categories_url).any?
      categories_page = shop_page.children.create({
        :title => "Categories",
        :link_url => categories_url,
        :menu_match => "^(/shop/categories)|#{categories_url}$",
        :show_in_menu => false,
        :deletable => false
      })
      categories_page.parts.create({
        :title => "Body",
        :body => "<p>This is the categories page.</p>",
        :position => 0
      })
    end
  end
end