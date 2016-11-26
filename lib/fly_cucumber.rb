class Fly_Cucumber

  def initialize platform, udid, application_name, feature

    #general configuation
    # changing these would require changes elsewhere
    @udid = udid
    @feature = feature.downcase
    @lib_directory = "automation"
    @results_data_output = "#{@lib_directory}/effects.txt"
    @results_media_directory = "www/runs/#{@udid}"
    @application_name = application_name
    
    here3

    #ios configuration
    @instruments_script = "#{@lib_directory}/effectScript.js"
    @instruments_header = "helpers/effects_header.js"
    @instruments_trace = "#{@lib_directory}/r1_photo_effects.trace"
    @instruments_template = "#{@lib_directory}/r1_photo_effects"

    #android configuration
    @uiautomator_script = "#{@lib_directory}/src/com/example/qa_demo/Testing.java"
    @uiautomator_script_template = "#{@lib_directory}/Testing.java"

    if platform == "ios"
      @on_ios = true
      @script = @instruments_script
    else
      @script = @uiautomator_script
    end

  end

  def prepare_line_for_execution test_data
    if @on_ios
      prepare_line_for_execution_ios test_data
    else
      prepare_line_for_execution_android test_data
    end
  end

  def identify_quotations_in line
    if line.include? '"'
      quotation = '"'
    else
      quotation = "'"
    end
    return quotation
  end

  def prepare_line_for_execution_ios test_data
    quotation_a = identify_quotations_in test_data['setup']['step_line']
    first_part = test_data['setup']['step_line'].split(quotation_a)[0]
    quotation_b = identify_quotations_in test_data['setup']['scenario_line']
    second_part = test_data['setup']['scenario_line'].split(quotation_b).join('')
    third_part = test_data['setup']['step_line'].split(quotation_a)[2]
    test_data['setup']['step_line'] = "#{first_part}\"#{second_part}\"#{third_part}"
    test_data['setup']['step_line'] = test_data['setup']['step_line'].split.join(' ')
  end

  def prepare_line_for_execution_android test_data
    line_method = test_data['setup']['step_line'].split("(")[0].split(" ")
    line_method=line_method[line_method.length-1]

    quotation = identify_quotations_in test_data['setup']['scenario_line']
    screen_shot_call = "screenShot(\"#{test_data['setup']['scenario_line'].strip.gsub(' ','_').split(quotation).join('_')}\");"

    test_data['setup']['uiautomator_functions'] = "#{test_data['setup']['uiautomator_functions']} #{line_method}#{test_data['setup']['function_count']}(); #{screen_shot_call}"
    line_a = test_data['setup']['step_line'].split("(")[0]
    line_b = test_data['setup']['step_line'].split(")")[1]
    test_data['setup']['step_line'] = "#{line_a}#{test_data['setup']['function_count']}()#{line_b}"
  end

  def extract_parameters_for_regex test_data
    if @on_ios
      parameters = test_data['setup']['step_line'][/function\(([^)]+)\)/].to_s
      parameters = parameters[9..-2]
    else
      parameters = test_data['setup']['step_line'][/\(([^)]+)\)/].to_s
      parameters = parameters[1..-2]
    end

    if !parameters.nil?
      if parameters.include? ","
        test_data['setup']['step_parameters'] = parameters.split(",")
      else
        test_data['setup']['step_parameters'][0] = parameters
      end
    end
  end

  def line_has_method_declaration test_data
    has_declaration = false
    if @on_ios
      if test_data['setup']['step_line'].include? "function"
        has_declaration = true
      end
    else
      if test_data['setup']['step_line'].include? "public"
        has_declaration = true
      end
    end
    return has_declaration
  end

  def evaluate_line test_data
    continue_writing_test = true
    has_declaration = line_has_method_declaration test_data
    if has_declaration
      if (((test_data['setup']['line_count'] != 0)  && @on_ios) || ((test_data['setup']['line_count'] != 1)  && !@on_ios))
        continue_writing_test = false
        test_data['setup']['line_count'] = -1
      else
        if test_data['results']['step_count'] > 0
          extract_parameters_for_regex test_data
          if test_data['setup']['function_count'] > 0 
            prepare_line_for_execution test_data
          end
        end
      end
    end
    return continue_writing_test
  end

  def write_test_function_to_executable_file test_data
    if test_data["setup"]["line_count"] > -1
      continue_writing_test = evaluate_line test_data
      if continue_writing_test && test_data['results']['step_count'] > 0
        if (@on_ios && test_data['setup']['line_count'] == 0) || (!@on_ios && test_data['setup']['line_count'] == 1)
          tgt = File.open("effects_temp", 'w')
          tgt.write(test_data['setup']['step_line'])
          tgt.close()
          cmd = "cat effects_temp >> #{@script}; echo '' >> #{@script}"
        else
          cmd = "sed '#{test_data['setup']['step_line_count']}q;d' #{test_data['setup']['step_line_file']} >> '#{@script}'"
        end
        %x(#{cmd})

        if test_data['setup']['step_parameters'].length > 0
          test_data['setup']['step_parameters'].each_with_index { | variable, index |
            cmd = "echo '  #{variable} = #{test_data['setup']['step_parameter_values'][index]};' >> '#{@script}'"
          %x(#{cmd})
          }
          test_data['setup']['step_parameter_values'].clear
          test_data['setup']['step_parameters'].clear
        end
        test_data['setup']['line_count'] = test_data['setup']['line_count'] + 1 
      end
    end
  end

  def identify_step_regex_values_from feature_file_line_words, step_file_line_words, test_data
    feature_file_line_words.each_with_index { | feature_file_line_word, index |
      if feature_file_line_word != step_file_line_words[index]
        test_data['setup']['step_parameter_values'].push feature_file_line_word
      end
    }
  end

  def does_step_title_have_keywords test_data, step_title
    has_given_when_then = false
    [
      "Given(",
      "When(",
      "Then(",
      "And("
    ].each {  | keyword |
      if test_data['setup']['step_line'].include? keyword
        if test_data['setup']['scenario_line'] =~ /(.*)#{step_title}(.*)/
          has_given_when_then = true
          break
        end
      end
    }
    return has_given_when_then
  end

  def match_scenario_steps test_data
    if test_data['setup']['scenario_line'].length > 4
      test_data['setup']['step_line_file'] = "features/step_definitions/#{test_data['setup']['feature']}_steps.rb"
      if File.exist?(test_data['setup']['step_line_file'])
        feature_steps = File.new(test_data['setup']['step_line_file'],"r")
        found_line = false
        line_count = 1
        while (test_data['setup']['step_line'] = feature_steps.gets)
          quotation = identify_quotations_in test_data['setup']['step_line']
          step_title = test_data['setup']['step_line'].split(quotation)[1]
          if !step_title.nil? && step_title.length > 4
            has_given_when_then = false
            has_given_when_then = does_step_title_have_keywords test_data, step_title
            if has_given_when_then
              puts "    -- #{test_data['setup']['scenario_line']}"
              words = test_data['setup']['scenario_line'].split(" ")
              words.shift
              identify_step_regex_values_from words, step_title.split(" "), test_data
              test_data["setup"]["line_count"] = 0
              test_data["setup"]["function_count"] = test_data["setup"]["function_count"] + 1
              test_data["results"]["step_count"] = test_data["results"]["step_count"] + 1
              found_line = true
            end
          end
          test_data['setup']['step_line_count'] = line_count
          write_test_function_to_executable_file test_data
          line_count = line_count + 1
        end
        feature_steps.close
      end
      if !found_line && ( test_data["setup"]["temp_scenario_count"] > 0 )
        puts "    * #{test_data['setup']['scenario_line']} [ Pending ]"
        test_data["results"]["undefined"].push test_data["setup"]["scenario_line"]
      end
    end
  end

  def prepare_next_scenario test_data
    %x(echo '#import "#{@instruments_header}"' > #{@instruments_script})
    %x(cat #{@uiautomator_script_template} > #{@uiautomator_script})
    test_data["results"]["scenario_count"] = test_data["results"]["scenario_count"] + 1
    test_data["setup"]["temp_scenario_count"] = test_data["setup"]["temp_scenario_count"] + 1
    test_data["setup"]["function_count"] = 0
    test_data['setup']['uiautomator_functions'] = ""
  end

  def run_available_test_before_scenarios test_data
    if test_data["setup"]["temp_scenario_count"] > 0
      run_test test_data
    end
  end

  def check_for_given_when_then_and scenario_line
    line_is_valid = false
    [
      "Given",
      "When",
      "Then",
      "And"
    ].each {  | keyword |
      if scenario_line.include? keyword
        line_is_valid = true
        break
      end
    }
    return line_is_valid
  end

  def identify_scenarios_in feature_file, test_data
    features = File.new(feature_file,"r")
    while (scenario_line = features.gets)
      test_data['setup']['feature'] = test_data['setup']['feature'].strip
      if scenario_line.include? "Scenario:"
        run_available_test_before_scenarios test_data
        prepare_next_scenario test_data
        puts "\n  #{scenario_line}"
        test_data['setup']['scenario_title'] = scenario_line
      else
        if !scenario_line.include? "Feature:"
          line_is_valid = check_for_given_when_then_and scenario_line
          if line_is_valid
            test_data['setup']['scenario_line'] = scenario_line
            match_scenario_steps test_data
          end
        end
      end
    end
  end

  def run_available_test_before_features test_data
    if test_data["results"]["step_count"] > 0
      run_test test_data
    end
  end

  def identify_new_feature_from feature_file, test_data 
    test_data['results']['feature_count'] = test_data['results']['feature_count'] + 1
    test_data["setup"]["temp_scenario_count"] = 0
    run_available_test_before_features test_data
    test_data['setup']['feature'] = feature_file.split(".")[0].split("/")[1]
    puts "\nFeature: #{test_data['setup']['feature']}"
    identify_scenarios_in feature_file, test_data

  end

  def display_results started_at, ended_at, test_data
    run_time = ended_at - started_at
    if test_data['results']['failures'].length > 0
      puts "\n\nFailures:"
      test_data['results']['failures'].each_with_index { | failure, index |
        puts failure
      puts "- #{test_data['results']['failure_detail'][index]}"
      }
    end
    puts "\nFeatures: #{test_data['results']['feature_count']}"
    puts "Scenarios: #{test_data['results']['scenario_count']}"
    puts "Steps: #{test_data['results']['step_count']}"
    puts "Failures: #{test_data['results']['failures'].length}"
    puts "Pending: #{test_data['results']['undefined'].length}"
    puts "#{run_time} seconds"
    if test_data['results']['failures'].length > 0
      abort("FOUND #{test_data['results']['failures'].length} ERRORS")
    end
  end

  def save_run_failures results, test_data
    test_data['results']['failures'].push "#{test_data['setup']['feature'].strip} | #{test_data['setup']['scenario_title'].strip} >> #{test_data['setup']['scenario_line'].strip}"
    if results.kind_of?(Array)
      test_data['results']['failure_detail'].push results.join(" | ")
    else
      test_data['results']['failure_detail'].push results
    end
  end

  def parse_results target
    cmd="grep -i #{target} #{@results_data_output} | grep -v 'kAXErrorFailure'"
    response=%x(#{cmd})
    return response
  end

  def run_ios_test results_directory, test_time, test_data
    cmd="instruments -D #{@instruments_trace} -w #{@udid} -t #{@instruments_template} #{@application_name} -e UIASCRIPT #{@instruments_script} -e UIARESULTSPATH #{results_directory}/ > #{@results_data_output}"
    %x(#{cmd})

    errors_and_failures = Array.new

    errors_and_failures = errors_and_failures.push (parse_results "error")
    errors_and_failures = errors_and_failures.push (parse_results "fail")

    errors_and_failures.delete_if { |error_failure|
      error_failure.empty?
    }

    if errors_and_failures.length == 0
      successes = parse_results "pass"
      if successes.include? "Pass"
        puts "    <<PASS>>"
      else
        puts "    missing UIALogger.logPass(test)"
      end
    else
      puts "    <<FAIL>>"
      save_run_failures errors_and_failures, test_data
    end
    create_metadata results_directory, test_time, errors_and_failures, test_data
  end

  def run_android_test results_directory, test_time, test_data

    cmd="echo 'public void runAll() throws UiObjectNotFoundException, InterruptedException, IOException {' >> #{@uiautomator_script}"
    %x(#{cmd})
    cmd="echo '#{test_data['setup']['uiautomator_functions']}' >>  #{@uiautomator_script}"
    %x(#{cmd})
    cmd="echo '}}' >> #{@uiautomator_script}"
    %x(#{cmd})
    cmd="adb shell rm -r /mnt/sdcard/Pictures/automation/ || true; adb shell mkdir /mnt/sdcard/Pictures/automation || true;"
    %x(#{cmd})
    cmd="cd #{@lib_directory}; ant build; adb push bin/testing.jar /data/local/tmp/"
    %x(#{cmd})
    cmd="adb shell uiautomator runtest testing.jar -c 'com.example.qa_demo.Testing#runAll' > #{@results_data_output}"
    %x(#{cmd})
    cmd="adb pull /mnt/sdcard/Pictures/automation/ #{results_directory}/"
    %x(#{cmd})

    cmdb="grep -i 'Failures:' #{@results_data_output} | cut -d' ' -f 6"
    res=%x(#{cmdb})
    cmdb="grep -i 'Errors:' #{@results_data_output} | cut -d' ' -f 9"
    resb=%x(#{cmdb})
    errors_and_failures = Array.new
    if res[0].to_i == 0 && resb.to_i == 0
      puts "    <<PASS>>"
    else
      puts "    <<FAIL>>"
      if res[0].to_i > 0
        errors_and_failures = errors_and_failures.push (parse_results "Failure in")
      else
        errors_and_failures = errors_and_failures.push (parse_results "Error in")
      end
      save_run_failures errors_and_failures, test_data
    end
    create_metadata results_directory, test_time, errors_and_failures, test_data
  end


  def run_test test_data
    test_time = Time.new().to_i
    results_directory = "#{@results_media_directory}/#{test_time}"
    %x([ -d "www/runs" ] || mkdir "www/runs")
    %x([ -d #{@results_media_directory} ] || mkdir #{@results_media_directory})
    %x(mkdir #{results_directory})

    if @on_ios
      run_ios_test results_directory, test_time, test_data
    else
      run_android_test results_directory, test_time, test_data
    end
  end

  def create_metadata results_directory, test_time, errors_and_failures, test_data
    target = File.open("#{results_directory}/meta.xml", 'w')
    target.write('<?xml version="1.0" encoding="UTF-8" ?>')
    if errors_and_failures.empty?
      errors_and_failures = ""
    end
    target.write("<test name='#{test_data['setup']['feature']} | #{test_data['setup']['scenario_title']} | #{test_data['setup']['scenario_line']}' date='#{test_time}' errors='#{errors_and_failures}'>")
    #    target.write("</test>")
    target.close()
  end


  def test_handler
    started_at = Time.now
    test_data = {
      "results" => {
      "failures" => Array.new, 
      "failure_detail" => Array.new, 
      "scenario_count" => 0, 
      "step_count" => 0,
      "feature_count" => 0,
      "undefined" => Array.new
    },
      "setup" => {
      "feature" => "",
      "line_count" => 0,
      "temp_scenario_count" => 0,
      "function_count" => 0,
      "uiautomator_functions" => "",
      "scenario_line" => "",
      "scenario_title" => "",
      "step_line" => "",
      "step_line_file" => "",
      "step_line_count" => 0,
      "step_line_match" => false,
      "step_parameters" => Array.new,
      "step_parameter_values" => Array.new
    }
    }

    if @feature == "all"
      Dir.glob("features/*.feature") do |feature_file|
        identify_new_feature_from feature_file, test_data
      end
    else
      feature_file = Dir.glob("features/#{@feature}.feature")[0]
      identify_new_feature_from feature_file, test_data
    end
    run_test test_data
    ended_at = Time.now
    display_results started_at, ended_at, test_data
  end
end

run_tests = Fly_Cucumber.new(ARGV[0],ARGV[1],ARGV[2],ARGV[3])
run_tests.test_handler

    
    here4
