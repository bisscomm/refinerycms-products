module Refinery
  module Products
    module ProductsHelper
      # See https://github.com/collectiveidea/awesome_nested_set/wiki/How-to-generate-nested-unordered-list-tags-with-one-DB-hit
      def nested_li(objects, &block)
        objects = objects.order(:lft) if objects.is_a? Class

        return '' if objects.size == 0

        output = '<ul><li>'
        path = [nil]

        objects.each_with_index do |o, i|
          if o.parent_id != path.last
            # We are on a new level, did we descend or ascend?
            if path.include?(o.parent_id)
              # Remove the wrong trailing path elements
              while path.last != o.parent_id
                path.pop
                output << '</li></ul>'
              end
              output << '</li><li>'
            else
              path << o.parent_id
              output << '<ul><li>'
            end
          elsif i != 0
            output << '</li><li>'
          end
          output << capture(o, path.size - 1, &block)
        end

        output << '</li></ul>' * path.length
        output.html_safe
      end
    end
  end
end