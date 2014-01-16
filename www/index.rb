#!/usr/bin/env ruby


require 'rubygems'
require 'optparse'
require 'nokogiri'
require 'date'

def parse_test_name(file)
  puts "parse_test_name:"
  puts file
  test_name = ""

  file_parts = file.split(/\./)
  suffix     = file_parts[0].split(/_/)
  suffix.shift
  puts suffix
  suffix.each { |word| test_name = test_name + "#{word} " }
  test_name
end

class TestSuite
  attr_accessor :udid, :tests
  def initialize(params)
    self.udid  = params[:udid]
    self.tests = params[:tests]
  end

  def to_html
    html_str = "<!DOCTYPE html>\n"
    html_str = html_str + "<html lang=\"en\" id=\"r1-effects-sdk-ios\">\n"
    html_str = html_str + "<head>\n"
    html_str = html_str + "<link href=\"./css/style.css\" rel=\"Stylesheet\" type=\"text/css\"/>\n"
    html_str = html_str + "</head>\n<body>\n"
    html_str = html_str + "<div id=\"left-column\"> test </div>\n"

    self.tests.each do |test|
      html_str = html_str + "<div style='padding: 1px;'>\n"
      html_str = html_str + "<h3>#{test.name} @ #{DateTime.strptime(test.date,'%s')} - #{self.tests.count} Total</h3>\n"
      test.files.each do |file|
        html_str = html_str + "<div style='float: left; padding: 5px;'>\n"
        html_str = html_str + "<img src='./runs/#{self.udid}/#{test.id}/#{file}' width='224' height='403'>\n"
        html_str = html_str + "<p>#{parse_test_name(file.to_s)}</p>\n"
        html_str = html_str + "</div>\n"
      end
      html_str = html_str + "</div>\n"
      html_str = html_str + "\n\n"
      html_str = html_str + "<div class='container'></div>\n"
      html_str = html_str + "\n\n"
    end
    html_str = html_str + "</body>\n</html>"

    html_str
  end
end

class Testfolder
  attr_accessor :id, :meta, :name, :date, :errors, :files
  def initialize(params)
    self.id = params[:id]
    self.meta = params[:meta]
    self.name = params[:name]
    self.date = params[:date]
    self.errors = params[:errors]
    self.files = params[:files]
  end
end

def output_help
  puts "usage: index.rb" 
end

@refresh = nil
def refresh
  @refresh = "-r"
end

def get_tests(udid)
  testsuite = TestSuite.new({:udid => udid, :tests => nil})
  tests = Array.new
  results = %x[./current.rb -u #{udid} #{@refresh}]
  raw_tests = results.split("\n")
  
  raw_tests.each do |xml|
    id = nil
    files = Array.new
    begin
      if xml =~ /'([0-9]+)'/
        id = $1
      end
      file = File.open("./runs/#{udid}/#{id}/meta.xml")
      meta = file.read
      file.close
      # parse meta file
      doc = Nokogiri::XML(meta)
      name   = doc.children[0].attributes['name'].value
      date   = doc.children[0].attributes['date'].value
      errors = doc.children[0].attributes['errors'].value
      doc.children.children.each { |node| 
        unless node.attributes["name"].nil?
          files << node.attributes["name"] 
        end
      }
      tests << Testfolder.new({:id => id, :meta => meta, :name => name, :date => date, :errors => errors, :files => files})
    rescue => e
      puts e.inspect
    end
  end # raw_tests
  testsuite.tests = tests
  testsuite
end


opts = OptionParser.new
OptionParser.new do |o|
  o.on('-h') { output_help; exit }
  o.on('-r') { refresh; }
  o.parse!
end

results = %x[ls runs]

hashes = Array.new
a_list = results.split("\n")
a_list.each do |file|
  hashes << file if file =~ /^[^.]+$/
end

a_suites = Array.new
hashes.each do |udid|
  a_suites <<  get_tests(udid)
end
puts "testsuites..."
a_suites.each do |testsuite|
  puts testsuite.udid
  puts testsuite.tests
  puts testsuite.to_html
  file = File.open("./#{testsuite.udid}.html", "w")
  file.write(testsuite.to_html)
  file.close
end
