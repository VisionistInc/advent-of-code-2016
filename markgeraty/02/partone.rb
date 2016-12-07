# file = File.open("sampleInput1.txt", "r")
file = File.open("input.txt", "r")
fileContents = file.read
input = fileContents.split("")

currentKey = 5
sequence = ""

input.each { |move|
  increment = 0

  case move
  when "U"
    (increment = -3) unless [1,2,3].include?(currentKey)
  when "R"
    (increment = 1) unless [3,6,9].include?(currentKey)
  when "D"
    (increment = 3) unless [7,8,9].include?(currentKey)
  when "L"
    (increment = -1) unless [1,4,7].include?(currentKey)
  when "\n"
    sequence <<= (currentKey.to_s)
  else
    puts "something wrong", move
  end

  currentKey += increment
}

puts sequence
