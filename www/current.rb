#!/usr/bin/env ruby


require 'rubygems'
require 'optparse'


def output_help
  puts "usage: current.rb -u UDID -r"
  puts "\t-u\tUDID"
  puts "\t-r\trefresh"
end

@refresh = 0
def refresh
  @refresh = 1
end

opts = OptionParser.new
OptionParser.new do |o|
  o.on('-u UDID ') { |udid| $udid = udid}
  o.on('-r') { refresh; }
  o.on('-h') { output_help; exit }
  o.parse!
end

@udid = $udid

begin 
  @udid = @udid.chomp
rescue => e
  @udid = '2d95ed1f4d56b6c769bebda9ba49f30cc25773d7' 
end



# copy directory from adam@173.203.204.15:/var/www/mobile/runs
if @refresh == 1
  puts "refreshing runs directory..."
  %x[rsync -auv adam@173.203.204.15:/var/www/mobile/runs ./] 
end

def get_results(udid)
  s_dir = "./runs/#{udid}"

  a_xml = Array.new
  listing = Dir.entries(s_dir) 
  listing.each do |file|
  
    if File.exists?("#{s_dir}/#{file}/meta.xml")
      if((file != "index.php") and (file !="iphone.js") and (file!="iphone.css") and (file.length >3))
        a_xml << "<test reference='#{file}'></test>"
      end
    end
  end
  a_xml
end

puts get_results(@udid)
