watch('chess/lib/(.*)\.rb') do |match_file|
  system('cls')
  success = system "ruby 'chess/run_all_tests.rb'"
  output = `ruby 'chess/run_all_tests.rb'`

  if success
    # i'm using a notification tool called growl.
    # unfortunately, here i have to use full path, because if i use relative path, growl just stops responding on my machine:
    system %Q{growlnotify /t:"OK" /i:"D:/Program Files/Ruby/Ruby193/bin/scripts/ok-icon.png" "row: #{output}.rb"}
    puts 'OK'
  else
    system %Q{growlnotify /t:"fail" /i:"D:/Program Files/Ruby/Ruby193/bin/scripts/fail-icon.png" "row: #{output}.rb"}
    puts 'fail'
  end
end

watch('chess/test/(.*)\.rb') do |match_file|
  system('cls')
  success = system "ruby 'chess/run_all_tests.rb'"
  output = `ruby 'chess/run_all_tests.rb'`

  if success
    system %Q{growlnotify /t:"OK" /i:"D:/Program Files/Ruby/Ruby193/scripts/ok-icon.png" "row: #{output}.rb"}
    puts 'OK'
  else
    system %Q{growlnotify /t:"fail" /i:"D:/Program Files/Ruby/Ruby193/scripts/fail-icon.png" "row: #{output}.rb"}
    puts 'fail'
  end
end

