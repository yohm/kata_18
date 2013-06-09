require File.join( File.dirname(__FILE__), '../lib/dependencies' )

path = ARGV[0]

io = File.open(path, 'r')
state = nil
gem_name = nil
dep = Dependencies.new
io.each do |line|
  if state == :in_gem_specs
    if line =~ /^\s{4}(\S+)/
      gem_name = $1
    elsif line =~ /^\s{6}(\S+)/
      raise "unexpected format" if gem_name.nil?
      dep_gem_name = $1
      dep.add_direct(gem_name, [dep_gem_name])
    elsif line.chomp.empty?
      state = nil
    else
      raise "unexpected format: #{line}, #{state}"
    end
  end
  state = :in_gem if line =~ /^GEM$/
  state = :in_gem_specs if state == :in_gem and line =~ /^\s{2}specs:$/
end

puts dep.to_heb_json