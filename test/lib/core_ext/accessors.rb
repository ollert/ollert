module SitePrism
  module Accessors
    def button(name, *args)
      extend_prism(name, *args) do |element_name|
        define_method(name) do
          send(element_name).click
        end
      end
    end

    def link(name, locator)
      args = case locator
               when String
                 [locator]
               else
                 ['a', locator]
             end

      extend_prism(name, *args) do |element_name|
        define_method(name) do
          send(element_name).click
        end
      end
    end

    def text_field(name, *args)
      extend_prism(name, *args) do |element_name|
        define_method(name) do
          send(element_name).value
        end

        define_method("#{name}=") do |value|
          send(element_name).set value
        end
      end
    end

    def label(name, *args)
      extend_prism(name, *args) do |element_name|
        define_method(name) do
          send(element_name).text
        end
      end
    end

    def extend_prism(name, *args, &block)
      element_name = "#{name}_element"
      element(element_name, *args)

      block.call(element_name)
    end
  end
end