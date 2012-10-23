class Fluent::FlattenOutput < Fluent::Output
  Fluent::Plugin.register_output('flatten', self)

  config_param :tag,        :string, :default => 'flatten'
  config_param :add_prefix, :string, :default => nil
  config_param :delimiter,  :string, :default => '_'

  def emit(tag, es, chain)
    if @add_prefix
      tag = @add_prefix + '.' + tag
    else
      tag = @tag
    end

    es.each do |time, record|
      record = flatten(record, {}, :delimiter => @delimiter)
      Fluent::Engine.emit(tag, time, record)
    end

    chain.next
  end

  def flatten(input = {}, output = {}, options = {})
    delimiter = options[:delimiter] || "_"
    input.each do |key, value|
      key = options[:prefix].nil? ? "#{key}" : "#{options[:prefix]}#{delimiter}#{key}"
      if value.is_a? Hash
        flatten(value, output, :prefix => key, :delimiter => delimiter)
      else
        output[key]  = value
      end
    end
    output
  end
end
