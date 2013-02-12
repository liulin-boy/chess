watch('chess/lib/(.*)\.rb') do |match_file|
  system('cls')

  success = system "ruby 'D:/Program Files/Ruby/Ruby193/bin/chess/run_all_tests.rb'"
  output = `ruby 'D:/Program Files/Ruby/Ruby193/bin/chess/run_all_tests.rb'`

#  success = system "ruby 'D:/Program Files/Ruby/Ruby193/bin/chess/specs/#{match_file[1]}_tester.rb'"
#  output = `ruby 'D:/Program Files/Ruby/Ruby193/bin/chess/specs/#{match_file[1]}_tester.rb'`

  if success
    system %Q{growlnotify /t:"OK" /i:"D:/Program Files/Ruby/Ruby193/bin/scripts/ok-icon.png" "row: #{output}.rb"}
    #OR
    #system "growlnotify /t:\"OK\" \"#{output}\""
    puts 'OK'
  else
    system %Q{growlnotify /t:"fail" /i:"D:/Program Files/Ruby/Ruby193/bin/scripts/fail-icon.png" "row: #{output}.rb"}
    puts 'fail'
  end
end

watch('chess/specs/(.*)\.rb') do |match_file|
  system('cls')
  success = system "ruby 'D:/Program Files/Ruby/Ruby193/bin/chess/run_all_tests.rb'"
  output = `ruby 'D:/Program Files/Ruby/Ruby193/bin/chess/run_all_tests.rb'`

#  success = system "ruby 'D:/Program Files/Ruby/Ruby193/bin/chess/specs/#{match_file[1]}.rb'"
#  output = `ruby 'D:/Program Files/Ruby/Ruby193/bin/chess/specs/#{match_file[1]}.rb'`

  if success
    system %Q{growlnotify /t:"OK" /i:"D:/Program Files/Ruby/Ruby193/scripts/ok-icon.png" "row: #{output}.rb"}
    #OR
    #system "growlnotify /t:\"OK\" \"#{output}\""
    puts 'OK'
  else
    system %Q{growlnotify /t:"fail" /i:"D:/Program Files/Ruby/Ruby193/scripts/fail-icon.png" "row: #{output}.rb"}
    puts 'fail'
  end
end

