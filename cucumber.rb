class Cucumber

  def initialize
    @scenario_test_count = 0
    @test_count = 0
    @line_count = -1
    @fail_count = 0
    @variables = Array.new
    @insert_value = Array.new
    @instruments_app = ARGV[0]
    @instruments_udid = ARGV[1]
    @instruments_script = "effectScript.js"
    @instruments_results = "effects.txt" 
    @instruments_trace = "automation/r1_photo_effects.trace"
    @instruments_template = "automation/r1_photo_effects"
    @instruments_results_path = "automation/data"
    @instruments_header = "automation/helpers/effects_header.js"
  end

  def reg_is a, b
    values = Array.new
    a.each_with_index { | word_from_a, index |
      if word_from_a != b[index]
        values.push word_from_a
      end
    }
    return values
  end

  def build variables, insert_value
    if variables.length > 0
      variables.each_with_index { | variable, index |
        cmd = "echo '  #{variable} = #{@insert_value[index]};' >> '#{@instruments_script}'"
      %x(#{cmd})
      }
    end
  end

  def run_test
    now = Time.new().to_i
    %x(mkdir #{@instruments_results_path}/#{now})
    cmd="instruments -D #{@instruments_trace} -w #{@instruments_udid} -t #{@instruments_template} #{@instruments_app} -e UIASCRIPT #{@instruments_script} -e UIARESULTSPATH #{@instruments_results_path}/#{now}/ > #{@instruments_results}"
    %x(#{cmd})
    cmdb="grep -i 'Pass' #{@instruments_results} | cut -d' ' -f 4"
    res=%x(#{cmdb})
    if res.include? "Pass"
      puts "    <<PASS>>"
    else
      puts "    <<FAIL>>"
      @fail_count = @fail_count + 1
    end

  end

  def scenarios 
    started_at = Time.now
    Dir.glob('features/*.feature') do |rb_file|
      @scenario_test_count = 0
      if @test_count > 0
        run_test
      end
      feature = rb_file.split(".")[0].split("/")[1]
      puts "\nFeature: #{feature}"
      file = File.new(rb_file,"r")
      while (line = file.gets)
        line = line.strip
        if line.include? "Scenario:"
          if @scenario_test_count > 0
            run_test
          end
          puts "\n  #{line}"
          %x(echo '#import "#{@instruments_header}"' > #{@instruments_script})
          @scenario_test_count = @scenario_test_count + 1
          @test_count = @test_count + 1
        end

        if line.length > 4

          fileb = File.new("features/step_definitions/#{feature}_steps.rb","r")
          while (lineb = fileb.gets)
            lineb_title = lineb.split('"')[1]
            if !lineb_title.nil? && lineb_title.length > 4
              if line =~ /(.*)#{lineb_title}(.*)/
                puts "    -- #{line}"
                words=line.split(" ")
                words.shift
                @insert_value=reg_is words, lineb_title.split(" ")
                @line_count=0
              end
            end

            if @line_count > -1
              if lineb.include? "function"
                if @line_count != 0
                  to_end=false
                  @line_count=-1
                else
                  function_variables = lineb[/function\(([^)]+)\)/].to_s
                  if function_variables.length > 0
                    function_variables = function_variables[9..-2]
                    if function_variables.include? ","
                      @variables = function_variables.split(",")
                    else
                      @variables[0] = function_variables
                    end
                  end
                  to_end= true
                end
              end
              if to_end
                cmd = "echo '#{lineb}' >> '#{@instruments_script}'"
                %x(#{cmd})
                if @variables.length > 0
                  build @variables, @insert_value
                  @variables.clear
                  @insert_value.clear
                end
                @line_count=@line_count+1
              end
            end

          end
          fileb.close
        end
      end
    end
    run_test
    ended_at = Time.now
    run_time = ended_at - started_at
    puts "\n\nTests: #{@test_count}\nFailures: #{@fail_count}"
    puts "#{run_time} seconds"
  end
end

start_tests=Cucumber.new
start_tests.scenarios
