require 'pp'

class Dependencies

  def initialize
    @dep = Hash.new
  end

  def add_direct(key, dependencies)
    @dep[key] = [] unless @dep.has_key?(key)
    @dep[key] += dependencies
    dependencies.each {|v| @dep[v] ||= [] }
  end

  def direct_dependencies_for(key)
    @dep[key] ? @dep[key].dup : nil
  end
end