# Fluent::Plugin::Flatten::Hash

## Synopsis

Imagin you have a config as below:

```
<match nested.**>
  type           flatten_hash
  add_tag_prefix flattend.
</match>
```

And you feed such a value into fluentd:

```
"nested" => {
  "foo"  => {"bar" => {"qux" => "quux", "hoe" => "poe" }, "baz" => "bazz" },
  "hoge" => "fuga"
}
```

Then you'll get re-emmited tag/record-s below:

```
"flattend.nested" => { "foo.bar.qux" => "quux", "foo.bar.hoe" => "poe", "foo.baz" => "bazz", "hoge" => "fuga" }
```
