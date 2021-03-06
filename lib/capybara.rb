# Monkey patching Capybara
module Capybara
  module Node
    class Element
      # Visually navigate to the element in order to interact with it.
      def locate
        path = self[:path]
        session.execute_script %{
            // Scroll to the element. It will appear at the top edge of the screen.
            element = document.evaluate(
                "//*[@path='#{path}']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null
            ).singleNodeValue.scrollIntoView();

            // Scroll a bit back so breadcrumbs are not hiding the element.
            window.scrollBy(0, -40);
        }
        return self
      end

      def check
        ensure_checkbox.set(true)
      end

      def uncheck
        ensure_checkbox.set(true)
      end

      def ensure_checkbox
        type = self[:type]
        elementDescription = !type ? tag_name : "#{tag_name} of type #{type}"

        raise "Element #{elementDescription} is not checkbox" if type != 'checkbox'

        return self
      end
    end
  end
end

# Introduce ':path' selector to find an element with matching path attribute
Capybara.add_selector(:path) do
  xpath { |path| XPath.descendant[XPath.attr(:path) == path.to_s] }
end