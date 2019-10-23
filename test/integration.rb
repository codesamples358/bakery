input_dir  = File.expand_path("../inputs", __FILE__)
output_dir = File.expand_path("../outputs", __FILE__)

generate = ARGV.first == 'gen'
passed   = true

Dir[ File.join(input_dir, '*') ].each do |file_path|
  file_name   = File.basename(file_path)
  output_file_path = File.join(output_dir, file_name)

  if generate
    `ruby bin/bakery_runner.rb #{file_path} > #{output_file_path}`
  else
    if File.exists?(output_file_path)
      `ruby bin/bakery_runner.rb #{file_path} > test/__tmp__`

      if File.read(output_file_path) != File.read("test/__tmp__")
        puts "Integration test '#{file_name}' failed"
        passed = false
      end
    end
  end
end

`rm -rf test/__tmp__`
if !generate && passed
  puts "Integration test: Ok."
end

