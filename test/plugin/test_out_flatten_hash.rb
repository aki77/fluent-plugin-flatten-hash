require 'test_helper'

class FlattenHashOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  DEFAULT_CONFIG = %[
    add_prefix        flattened
  ]

  def create_driver(conf = DEFAULT_CONFIG, tag = 'test')
    Fluent::Test::OutputTestDriver.new(Fluent::FlattenHashOutput, tag).configure(conf)
  end

  def test_configure
    d1 = create_driver

    assert_equal 'flattened', d1.instance.add_prefix
  end

  def test_flatten
    d = create_driver

    flattened = d.instance.flatten({ 'foo' => { 'bar' => 'baz' }, 'hoge' => 'fuga' })
    assert_equal({ 'foo.bar' => 'baz', 'hoge' => 'fuga'  }, flattened)

    flattened = d.instance.flatten({ 'foo' => { 'bar' => 'baz' }, 'hoge' => 'fuga' }, {}, :delimiter => '_')
    assert_equal({ 'foo_bar' => 'baz', 'hoge' => 'fuga'  }, flattened)
  end

  def test_emit
    # test1 default config
    d1 = create_driver

    d1.run do
      d1.emit({ 'foo' => { 'bar' => 'baz' }, 'hoge' => 'fuga' })
      d1.emit({ 'foo' => { 'bar' => { 'qux' => 'quux', 'hoe' => 'poe' }, 'baz' => 'bazz' }, 'hoge' => 'fuga' })
    end
    emits1 = d1.emits

    assert_equal 2, emits1.count

    # ["flattened.test", 1354689632, {"foo.bar"=>"baz", "hoge"=>"fuga"}]
    assert_equal     'flattened.test', emits1[0][0]
    assert_equal                'baz', emits1[0][2]['foo.bar']

    # ["flattened.foo.bar.qux", 1354689632, {"foo.bar.qux"=>"quux", "foo.bar.hoe"=>"poe", "foo.baz"=>"bazz", "hoge"=>"fuga"}]
    assert_equal 'flattened.test', emits1[1][0]
    assert_equal           'quux', emits1[1][2]['foo.bar.qux']
  end
end
