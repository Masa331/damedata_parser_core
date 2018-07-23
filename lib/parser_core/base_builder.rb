module ParserCore
  module BaseBuilder
    include Mega

    attr_accessor :name, :data, :options, :namespaces

    def initialize(name, data = {}, options = {})
      @name = name
      @data = data || {}
      @options = options || {}
      @namespaces = options[:namespaces] || {}
    end

    def to_xml
      encoding = options[:encoding]

      doc_options = { version: '1.0' }
      doc_options[:encoding] = encoding if encoding
      doc = Ox::Document.new(doc_options)
      doc << builder

      dump_options = { with_xml: true }
      dump_options[:encoding] = encoding if encoding
      Ox.dump(doc, dump_options)
    end

    def build_element(name, content, attributes = {})
      attributes ||= attributes || {}

      element = Ox::Element.new(name)

      attributes.each { |k, v| element[k] = v }

      element << content if content

      element
    end

    def builder
      root = Ox::Element.new(name)

      root
    end

    def add_attributes_and_namespaces(node)
      if data.key? :attributes
        data[:attributes].each { |k, v| node[k] = v }
      end

      if namespaces.any?
        namespaces.each do |prefix, uri|
          node["xmlns:#{prefix}"] = uri
        end
      end

      node
    end
  end
end

