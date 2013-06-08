require 'pp'
require 'json'

class Dependencies

  def initialize
    @direct_dep = Hash.new
  end

  def parse(str)
    str.each_line do |line|
      key = line.split.first
      dep = line.split[1..-1]
      add_direct(key, dep)
    end
  end

  def add_direct(key, dependencies)
    @direct_dep[key] = [] unless @direct_dep.has_key?(key)
    @direct_dep[key] += dependencies
    dependencies.each {|v| @direct_dep[v] ||= [] }
  end

  def direct_dependencies_for(key)
    @direct_dep[key] ? @direct_dep[key].dup : nil
  end

  def dependencies_for(key, investigated = [])
    investigated << key
    dependencies = @direct_dep[key] - investigated
    (@direct_dep[key] - investigated).each do |v|
      dependencies += dependencies_for(v, investigated)
    end
    dependencies.uniq.sort
  end

  # return json data for d3.js rendering (hierarchical edge bundling)
  # See http://bl.ocks.org/mbostock/5672200
  def to_heb_json
    arr = []
    @direct_dep.keys.each do |key|
      arr << {name: key, size: 1, imports: dependencies_for(key)}
    end
    arr.to_json
  end
end