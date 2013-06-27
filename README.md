# Fluent::Plugin::Flatten::Hash

## Configuration

    <match nested.log>
      type flatten_hash
      add_prefix flatten
    </match>

    <match flatten.nested.log>
      type tdlog
      apikey YOUR_API_KEY
      auto_create_table
      buffer_type file
      buffer_path /var/log/td-agent/buffer/td
    </match>
