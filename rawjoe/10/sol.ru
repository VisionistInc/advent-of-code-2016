#!/usr/bin/env ruby

hash = {}

cmds = Array.new

File.open('input').each do |line|
  cmds.push line
end

while cmds.count > 0  do
    i = 0
    cmds.each do |cmd|
        params = cmd.split
        if params[0] == 'value'
            cmds.delete_at(i)
            bot = params[4] + " " + params[5]
            val = params[1]
            unless hash.key?(bot)
                hash[bot] = []
            end
            hash[bot].push(val)
            break
        elsif params[0] == 'bot'
            bot = params[0] + " " + params[1]
            lowdest = params[5] + " " + params[6]
            highdest = params[10] + " " + params[11]
            
            unless hash.key?(bot) && hash[bot].count > 1
                i = i + 1
                next
            end

            cmds.delete_at(i)
            low = hash[bot].pop
            high = hash[bot].pop
            if low.to_i > high.to_i
                tmp = low
                low = high
                high = tmp
            end

            unless hash.key?(lowdest)
                hash[lowdest] = []
            end
            hash[lowdest].push(low)

            unless hash.key?(highdest)
                hash[highdest] = []
            end
            hash[highdest].push(high)
            
            if low == '17' && high == '61'
                print "Bot #{params[1]}\n"
            end
            break
        else
            cmds.delete_at(i)
            break
        end
    end
end

a = hash['output 0'].pop.to_i * hash['output 1'].pop.to_i * hash['output 2'].pop.to_i
print "#{a}\n"
