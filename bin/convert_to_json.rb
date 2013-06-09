require File.join( File.dirname( File.expand_path(__FILE__)), '../lib/dependencies' )

unless ARGV[0]
  $stderr.puts "Specify dependency file"
  raise "No input"
end

input = File.open(ARGV[0], 'r').read
dep = Dependencies.new
dep.parse(input)
$stdout.puts dep.to_heb_json
