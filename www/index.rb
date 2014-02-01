#!/usr/bin/env ruby


require 'rubygems'
require 'optparse'
require 'nokogiri'
require 'date'

def parse_test_name(file)
  # puts "parse_test_name:"
  # puts file
  test_name = ""

  file_parts = file.split(/\./)
  suffix     = file_parts[0].split(/_/)
  suffix.shift
  # puts suffix
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
    html_str = html_str + "<div id=\"mainbox\">\n"

    #
    # left column
    #
    html_str = html_str + "<div id=\"left-column\">\n"
    i = 1
    self.tests.each do |test|
      begin
        if test.errors.length > 0
          error_txt   = "<div class='error'>\n"
          error_txt   = error_txt + "#{test.parse}"
          error_txt   = error_txt + "</div>"
        end
      rescue => e
        puts e.message
      end
      html_str = html_str + "<div class='tname_small' ><a href='\#test#{i}'>#{test.name}</a> (#{DateTime.strptime(test.date,'%s')}) #{error_txt}</div>\n"
      i = i + 1
      test.files.each do |file|
        error_border = ''
        test.parsed_errors.each {|s|
          # TODO: figure out the proper match later
          #if file.to_s =~ /(#{s})/
            error_border = 'border: 1px #FA8072 solid;'
          #end
        } 
        html_str = html_str + "<div style='float: left; padding: 1px;#{error_border}'>\n"
        html_str = html_str + "<img src='./runs/#{self.udid}/#{test.id}/#{file}' width='27' height='54'>\n"
        html_str = html_str + "</div>\n"
      end
      test.parsed_errors = Array.new
    end
    html_str = html_str + "</div>\n <!-- end left column -->"


    # 
    # right column
    #
    i = 1
    html_str = html_str + "<div id=\"right-column\">\n"
    self.tests.each do |test|
      begin
        if test.errors.length > 0
          error_txt   = "<div class='error'>\n"
          error_txt   = error_txt + "#{test.parse}"
          error_txt   = error_txt + "</div>"
        end
      rescue => e
        puts e.message
      end
      html_str = html_str + "<div style='padding: 1px;overflow:auto'>\n"
      html_str = html_str + "<div style='padding: 1px;overflow:auto'>\n"
      html_str = html_str + "<h3><a id='test#{i}'>#{test.name}</a> @ #{DateTime.strptime(test.date,'%s')}<br/>#{error_txt}</h4>"
      i = i + 1
      test.files.each do |file|
        error_border = ''
        test.parsed_errors.each {|s|
          # TODO: figure out the proper match later
          # if file.to_s =~ /(#{s})/
            error_border = 'border: 1px #FA8072 solid;'
          # else 
          #   error_border = 'border: 1px black solid;'
          # end
        } 
        html_str = html_str + "<div class='image_box' style='float: left; margin: 2px; padding: 5px;'>\n"
        html_str = html_str + "<img src='./runs/#{self.udid}/#{test.id}/#{file}' width='224px' height='403px' style='#{error_border}'>\n"
        html_str = html_str + "<p>#{parse_test_name(file.to_s)}</p>\n"
        html_str = html_str + "</div>\n"
      end
      html_str = html_str + "</div>\n"
      html_str = html_str + "\n\n"
      # html_str = html_str + "<div class='container'></div>\n"
      html_str = html_str + "<div></div>\n"
      html_str = html_str + "\n\n"
      html_str = html_str + "<hr>\n"
    end
    html_str = html_str + "</div>\n <!-- end right column -->"
    html_str = html_str + "</div>\n <!-- end mainbox --> "
    html_str = html_str + "</body>\n</html>"

    html_str
  end
end

class Testfolder
  attr_accessor :id, :meta, :name, :date, :errors, :files, :parsed_errors
  def initialize(params)
    self.id = params[:id]
    self.meta = params[:meta]
    self.name = params[:name]
    self.date = params[:date]
    self.errors = params[:errors]
    self.files = params[:files]
    self.parsed_errors = Array.new
  end
  
  def parse
    self.errors = self.errors.gsub("[\"","")
    self.errors = self.errors.gsub("\"]","")
    self.errors = self.errors.gsub("\\n","")
    a_errors = self.errors.split(",")

    begin
      a_errors.each do |s_error|
        puts s_error
        # a_tmp = s_error.split(/Fail: /)
        # self.parsed_errors << a_tmp[1]
        self.parsed_errors << s_error
      end
    rescue => e
      puts e.message
    end
    "#{a_errors.count} error(s) : #{self.parsed_errors.join(" ")}"
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
  o.on('-u UDID') { |udid| $udid = udid }
  o.on('-s STATE') { |state| $state= state}
  o.parse!
end

@udid = $udid

working_directory = ""
results = %x[ls runs]

hashes = Array.new
a_list = results.split("\n")
a_list.each do |file|
  if @udid.nil?
    hashes << file if file =~ /^[^.]+$/
  else
    if file == @udid
      hashes << file if file =~ /^[^.]+$/
    end
  end
end

a_suites = Array.new
hashes.each do |udid|
  a_suites <<  get_tests(udid)
end
puts "Generating testsuite(s)..."
a_suites.each do |testsuite|
  # puts testsuite.udid
  # puts testsuite.tests
  # puts testsuite.to_html
  file = File.open("./#{testsuite.udid}.html", "w")
  file.write(testsuite.to_html)
  file.close
end
puts "Generating testsuite(s) complete."
