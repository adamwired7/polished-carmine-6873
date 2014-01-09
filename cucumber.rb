class Cucumber

  def initialize
    @scenario_test_count = 0
    @test_count = 0
    @line_count = -1
    @fail_count = 0
    @function_count = 0
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
    @to_end = false

    @on_ios = true
    @script = @instruments_script
    if @platform == "android"
      @on_ios = false
      @script = @uiautomator_script
    end

  end

  def parameters_are a, b
    values = Array.new
    a.each_with_index { | word_from_a, index |
      if word_from_a != b[index]
        values.push word_from_a
      end
    }
    return values
  end

  def build_executable_script
    if @variables.length > 0
      @variables.each_with_index { | variable, index |
        cmd = "echo '  #{variable} = #{@insert_value[index]};' >> '#{@script}'"
      %x(#{cmd})
      }
    end
  end

  def run_test
    results_directory = "#{@instruments_results_path}/#{Time.new().to_i}"
    %x([ -d #{@instruments_results_path} ] || mkdir #{@instruments_results_path})
    %x(mkdir #{results_directory})

    if @on_ios
      run_ios_test results_directory
    else
      run_android_test results_directory
    end
  end

  def save_run_failures results
    @failures.push @current_test
    @failure_detail.push results
    @fail_count = @fail_count + 1
  end

  def run_ios_test results_directory
    cmd="instruments -D #{@instruments_trace} -w #{@instruments_udid} -t #{@instruments_template} #{@instruments_app} -e UIASCRIPT #{@instruments_script} -e UIARESULTSPATH #{results_directory}/ > #{@instruments_results}"
    %x(#{cmd})

    cmdb="grep -i 'Pass' #{@instruments_results} | cut -d' ' -f 4"
    res=%x(#{cmdb})
    if res.include? "Pass"
      puts "    <<PASS>>"
    else
      puts "    <<FAIL>>"
      cmdc="grep -i 'Fail' #{@instruments_results} | cut -d':' -f 4"
      resc=%x(#{cmdc})
      save_run_failures resc
    end
  end

  def run_android_test results_directory
    cmd="echo '}' >> #{@uiautomator_script}"
    %x(#{cmd})
    cmd="adb shell rm -r /mnt/sdcard/Pictures/automation/ || true; adb shell mkdir /mnt/sdcard/Pictures/automation || true;"
    %x(#{cmd})
    cmd="cd #{@uiautomator_test_directory}; ant build; adb push bin/testing.jar /data/local/tmp/"
    %x(#{cmd})
    cmd="adb shell uiautomator runtest testing.jar #{@build_test} > #{@instruments_results}"
    %x(#{cmd})
    cmd="adb pull /mnt/sdcard/Pictures/automation/ #{results_directory}/"
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
      save_run_failures resc
    end
  end

  def split_parameters function_variables
    if function_variables.include? ","
      @variables = function_variables.split(",")
    else
      @variables[0] = function_variables
    end
  end

  def line_has_method_declaration lineb
    included = false
    if @on_ios
      if lineb.include? "function"
        included = true
      end
    else 
      if lineb.include? "public"
        included = true
      end
    end
    return included
  end

  def extract_parameters lineb
    if @on_ios
      function_variables = lineb[/function\(([^)]+)\)/].to_s
    else
      function_variables = lineb[/\(([^)]+)\)/].to_s
    end
    return function_variables
  end

  def prepare_test_execution lineb
    if !@on_ios
      method = lineb.split("(")[0].split(" ")
      method=method[method.length-1]
      @build_test = "#{@build_test} -c 'com.example.qa_demo.Testing##{method}#{@function_count}'"
      lineb_a = lineb.split("(")[0]
      lineb_b = lineb.split(")")[1]
      lineb = "#{lineb_a}#{@function_count}()#{lineb_b}"
    end
    return lineb
  end

  def evaluate_line lineb
    included = line_has_method_declaration lineb
    if included
      if @line_count != 0
        @to_end=false
        @line_count=-1
      else
        function_variables = extract_parameters lineb
        lineb = prepare_test_execution lineb
        if function_variables.length > 0
          if @on_ios
            function_variables = function_variables[9..-2]
          else
            function_variables = function_variables[1..-2]
          end
          split_parameters function_variables
        end
        @to_end = true
      end
    end
    return lineb
  end

  def prep_next_test line, feature
    puts "\n  #{line}"
    @current_test = "#{feature} / #{line}"
    %x(echo '#import "#{@instruments_header}"' > #{@instruments_script})
    %x(cat #{@uiautomator_test_template} > #{@uiautomator_script})
    @build_test=""
    @scenario_test_count = @scenario_test_count + 1
    @test_count = @test_count + 1
    @function_count = 0
  end

  def copy_test_function lineb
    if @line_count > -1
      lineb=evaluate_line lineb
      if @to_end
        cmd = "echo '#{lineb}' >> '#{@script}'"
        %x(#{cmd})
        if @variables.length > 0
          build_executable_script
          @variables.clear
          @insert_value.clear
        end
        @line_count=@line_count+1
      end
    end
  end


  def steps feature, line
    if line.length > 4
      fileb = File.new("features/step_definitions/#{feature}_steps.rb","r")
      while (lineb = fileb.gets)
        lineb_title = lineb.split('"')[1]
        if !lineb_title.nil? && lineb_title.length > 4
          if line =~ /(.*)#{lineb_title}(.*)/
            puts "    -- #{line}"
            words=line.split(" ")
            words.shift
            @insert_value=parameters_are words, lineb_title.split(" ")
            @line_count=0
            @function_count=@function_count + 1
          end
        end

        copy_test_function lineb
      end
      fileb.close
    end
  end

  def scenarios 
    started_at = Time.now
    Dir.glob("features/*.feature") do |feature_file|
      @scenario_test_count = 0
      if @test_count > 0
        run_test
      end
      feature = feature_file.split(".")[0].split("/")[1]
      puts "\nFeature: #{feature}"
      file = File.new(feature_file,"r")
      while (line = file.gets)
        line = line.strip
        if line.include? "Scenario:"
          if @scenario_test_count > 0
            run_test
          end
          prep_next_test line, feature
        end
        steps feature, line
      end
    end
    run_test
    ended_at = Time.now
    display_results started_at, ended_at
  end

  def display_results started_at, ended_at
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
