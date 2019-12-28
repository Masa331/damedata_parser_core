module ParserCore
  module BaseParser
    include Mega
    EMPTY_ARRAY = []

    attr_accessor :raw

    def initialize(raw)
      @raw = raw
    end

    def attributes
      raw.attributes
    end

    private

    def at(locator)
      return nil if raw.nil?

      element = raw.locate(locator.to_s).first

      if element
        if element.nodes.any? && element.nodes.all? { |node| node.is_a? Ox::CData }
          element.nodes.first.value
        else
          element.text
        end
      end
    end

    def attributes_at(locator)
      return nil if raw.nil?

      element = raw.locate(locator.to_s).first

      if element
        element.attributes
      end
    end

    def has?(locator)
      raw.locate(locator).any?
    end

    def submodel_at(klass, locator)
      element_xml = raw.locate(locator).first

      klass.new(element_xml) if element_xml
    end

    def array_of_at(klass, locator)
      return EMPTY_ARRAY if raw.nil?

      elements = raw.locate([*locator].join('/'))

      if klass == String && locator.size == 2
        elements.map do |element|
          klass.new(element.nodes.first)
        end
      else
        elements.map do |element|
          klass.new(element)
        end
      end
    end

    def to_h
      {}
    end
  end
end
