module Fluent
  class FlattenHashOutput < Fluent::Output
    Fluent::Plugin.register_output('flatten_hash', self)

    config_param :delimiter,  :string, :default => '.'

    include HandleTagNameMixin

    def configure(conf)
      super

      if (
          !@remove_tag_prefix &&
          !@remove_tag_suffix &&
          !@add_tag_prefix    &&
          !@add_tag_suffix
      )
        raise Fluent::ConfigError, "At least one of remove_tag_prefix/remove_tag_suffix/add_tag_prefix/add_tag_suffix is required to be set"
      end
    end

    def emit(tag, es, chain)
      es.each do |time, record|
        new_tag = tag.clone
        new_record = flatten(record)

        filter_record(new_tag, time, new_record)
        Fluent::Engine.emit(new_tag, time, new_record)
      end

      chain.next
    end

    def flatten(input = {}, output = {}, prefix = nil)
      input.each do |key, value|
        key = "#{prefix}#{@delimiter}#{key}" unless prefix.nil?
        if value.is_a? Hash
          flatten(value, output, key)
        else
          output[key]  = value
        end
      end
      output
    end
  end
end
