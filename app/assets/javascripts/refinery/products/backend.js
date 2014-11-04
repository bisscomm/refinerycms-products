$(document).ready(function(){
  $('.products_properties').find('input[type="checkbox"]:not(:checked)').each(function() {
    toggle_product_property_textarea($(this));
  });

  $('.products_properties input[type="checkbox"]').click(function(event) {
    toggle_product_property_textarea($(this));
  });

  function toggle_product_property_textarea(checkbox) {
    if( checkbox.is(':checked') ) {
      checkbox.closest('li').find('textarea').prop("disabled", false);
    } else {
      checkbox.closest('li').find('textarea').prop("disabled", true);
    }
  }

  page_options.init(false, '', '');
});