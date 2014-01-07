class Cucumber

  def initialize
    @scenario_test_count = 0
    @test_count = 0
    @line_count = -1
    @fail_count = 0
    @current_test = ""
    @variables = Array.new
    @insert_value = Array.new
    @failures = Array.new
    @failure_detail = Array.new
    @platform = ARGV[0]
    @instruments_app = ARGV[1]
    @instruments_udid = ARGV[2]
    @instruments_script = "effectScript.js"
    @instruments_results = "effects.txt" 
    @instruments_trace = "automation/r1_photo_effects.trace"
    @instruments_template = "automation/r1_photo_effects"
    @instruments_results_path = "automation/data"
    @instruments_header = "automation/helpers/effects_header.js"
    @uiautomator_test_directory = "automation"
    @uiautomator_script = "automation/src/com/example/qa_demo/Testing.java"
    @uiautomator_test_template = "automation/Testing.java"
    @build_test = ""

    @on_ios=true
    if @platform == "android"
      @on_ios = false
    end

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
    %x([ -d #{@instruments_results_path} ] || mkdir #{@instruments_results_path})
    %x(mkdir #{@instruments_results_path}/#{now})
    if @on_ios
      cmd="instruments -D #{@instruments_trace} -w #{@instruments_udid} -t #{@instruments_template} #{@instruments_app} -e UIASCRIPT #{@instruments_script} -e UIARESULTSPATH #{@instruments_results_path}/#{now}/ > #{@instruments_results}"
      %x(#{cmd})

      cmdb="grep -i 'Pass' #{@instruments_results} | cut -d' ' -f 4"
      res=%x(#{cmdb})
      if res.include? "Pass"
        puts "    <<PASS>>"
      else
        puts "    <<FAIL>>"
        cmdc="grep -i 'Fail' #{@instruments_results} | cut -d':' -f 4"
        resc=%x(#{cmdc})
        @failures.push @current_test
        @failure_detail.push resc
        @fail_count = @fail_count + 1
      end
    else
      cmd="echo '}' >> #{@uiautomator_script}"
      %x(#{cmd})
      cmd="adb shell rm -r /mnt/sdcard/Pictures/automation/ || true; adb shell mkdir /mnt/sdcard/Pictures/automation || true;"
      %x(#{cmd})
      cmd="cd #{@uiautomator_test_directory}; ant build; adb push bin/testing.jar /data/local/tmp/"
      %x(#{cmd})
      cmd="adb shell uiautomator runtest testing.jar #{@build_test} > #{@instruments_results}"
      %x(#{cmd})
      cmd="adb pull /mnt/sdcard/Pictures/automation/ #{@instruments_results_path}/#{now}/"
      %x(#{cmd})

      cmdb="grep -i 'Failures:' #{@instruments_results} | cut -d' ' -f 6"
      res=%x(#{cmdb})
      cmdb="grep -i 'Errors:' #{@instruments_results} | cut -d' ' -f 9"
      resb=%x(#{cmdb})
      if res[0].to_i == 0 && resb.to_i == 0
        puts "    <<PASS>>"
      else
        puts "    <<FAIL>>"
        if res[0].to_i > 0
          cmdc="grep -i 'Failure in' #{@instruments_results} | cut -d' ' -f 3"
        else
          cmdc="grep -i 'Error in' #{@instruments_results} | cut -d' ' -f 3"
        end
        resc=%x(#{cmdc})
        @failures.push @current_test
        @failure_detail.push resc
        @fail_count = @fail_count + 1
      end
    end
  end

  def splitParams function_variables
    if function_variables.include? ","
      @variables = function_variables.split(",")
    else
      @variables[0] = function_variables
    end
  end

  def lineHandler lineb, to_end

    included = false
    if @on_ios
      if lineb.include? "function"
        included = true
      end
    else
      if lineb =~ /(.*)Given(.*)/ || lineb =~ /(.*)When(.*)/ || lineb =~ /(.*)Then(.*)/
        included = true
      end
    end
    if included
      if @line_count != 0
        to_end=false
        @line_count=-1
      else
        function_variables = ""
        if @on_ios
          function_variables = lineb[/function\(([^)]+)\)/].to_s
        else
          if lineb.include? "public"
            function_variables = lineb[/\(([^)]+)\)/].to_s
            method = lineb.split("(")[0].split(" ")
            method=method[method.length-1]
            @build_test = "#{@build_test} -c 'com.example.qa_demo.Testing##{method}'"
          end
        end
        if function_variables.length > 0
          if @on_ios
            function_variables = function_variables[9..-2]
          else
            function_variables = function_variables[1..-2]
          end
          splitParams function_variables
        end
        to_end = true
      end
    end
    return to_end
  end

  def scenarios 
    started_at = Time.now
    Dir.glob("#{@platform}/features/*.feature") do |rb_file|
      @scenario_test_count = 0
      if @test_count > 0
        run_test
      end
      feature = rb_file.split(".")[0].split("/")[2]
      puts "\nFeature: #{feature}"
      file = File.new(rb_file,"r")
      while (line = file.gets)
        line = line.strip
        if line.include? "Scenario:"
          if @scenario_test_count > 0
            run_test
          end
          puts "\n  #{line}"
          @current_test = "#{feature} / #{line}"
          %x(echo '#import "#{@instruments_header}"' > #{@instruments_script})
          %x(cat #{@uiautomator_test_template} > #{@uiautomator_script})
          @build_test=""
          @scenario_test_count = @scenario_test_count + 1
          @test_count = @test_count + 1
        end

        if line.length > 4

          fileb = File.new("#{@platform}/features/step_definitions/#{feature}_steps.rb","r")
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

              to_end=lineHandler lineb, to_end

              if to_end
                if @on_ios
                  cmd = "echo '#{lineb}' >> '#{@instruments_script}'"
                  %x(#{cmd})
                  if @variables.length > 0
                    build @variables, @insert_value
                    @variables.clear
                    @insert_value.clear
                  end
                else
                  cmd = "echo '#{lineb}' >> '#{@uiautomator_script}'"
                  %x(#{cmd})
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

    if @failures.length > 0
      puts "\n\nFailures:"
      @failures.each_with_index { | failure, index |
        puts failure
      puts "- #{@failure_detail[index]}"
      }
    end

    puts "\nScenarios: #{@scenario_test_count}"
    puts "Steps: #{@test_count}\nFailures: #{@fail_count}"
    puts "#{run_time} seconds"
  end
end

start_tests=Cucumber.new
start_tests.scenarios
