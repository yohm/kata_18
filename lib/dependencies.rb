require 'pp'

class Dependencies

  def initialize
    @direct_dep = Hash.new
  end

  def add_direct(key, dependencies)
    @direct_dep[key] = [] unless @direct_dep.has_key?(key)
    @direct_dep[key] += dependencies
    dependencies.each {|v| @direct_dep[v] ||= [] }
  end

  def direct_dependencies_for(key)
    @direct_dep[key] ? @direct_dep[key].dup : nil
  end

  def dependencies_for(key)
    dependencies = @direct_dep[key]
    @direct_dep[key].each do |d|
      dependencies += dependencies_for(d)
    end
    pp key, dependencies, @direct_dep
    dependencies.uniq.sort
  end
end