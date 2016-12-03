# for part 2, run with flag --alpha

#file = File.open("sampleInput1.txt", "r")
file = File.open("input.txt", "r")
fileContents = file.read
input = fileContents.split("")

sequence = ""

# part 1 numeric keypad
currentCell = [2, 0]
keypad = [
  ["1", "2", "3"],
  ["4", "5", "6"],
  ["7", "8", "9"]
];

if ARGV.include?("--alpha")
  # part 2 alphanumeric keypad
  currentCell = [2, 0]
  keypad = [
    ["0", "0", "1", "0", "0"],
    ["0", "2", "3", "4", "0"],
    ["5", "6", "7", "8", "9"],
    ["0", "A", "B", "C", "0"],
    ["0", "0", "D", "0", "0"]
  ];
end

input.each { |move|
  newCell = [currentCell[0], currentCell[1]]

  case move
  when "U"
    (newCell[0] -= 1) unless newCell[0] == 0
  when "R"
    (newCell[1] += 1) unless newCell[1] == keypad[currentCell[0]].length - 1
  when "D"
    (newCell[0] += 1) unless newCell[0] == keypad.length - 1
  when "L"
    (newCell[1] -= 1) unless newCell[1] == 0
  when "\n"
    sequence <<= keypad[currentCell[0]][currentCell[1]]
  else
    puts "something wrong", move
  end

  # part 2 is not a square, so one additional check to see if the space is valid
  if "0" != keypad[newCell[0]][newCell[1]]
    currentCell = newCell
  end
}

puts sequence
