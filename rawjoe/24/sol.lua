-- track how many rows and cols are in the maze
rows = 1
cols = 1

-- track where we enter the maze
start_row = 0
start_col = 0

-- track how many stops we need to make in the maze
stops = 0

-- save off actual maze based on input
maze = {}

-- tracks each x/y in maze, how many moves it took to get there
state = {}

-- moves counter
moves = 0

-- helper function for making next move
function checkMove (h,w,v)
    -- if next move is into wall, ignore
    if maze[h][w] == "#" then
        return
    end

    -- if next move is to a number, include that number
    -- when we assign moves
    if not (maze[h][w] == ".") then
        v = bit32.bor(v, (2 ^ tonumber(maze[h][w])))
    end

    -- check to see if, for a given state, we haven't been there
    -- and if we haven't, mark us as there
    if state[h][w][v] == -1 then
        state[h][w][v] = moves + 1
    end
end

fp = io.open( "input", "r" )

-- for each line in the file
for line in fp:lines() do
    -- if it's an actual line
    if string.len(line) > 0 then
        -- create an array to hold each col in the row
        maze[rows] = {}

        -- for each char in the line
        for x=1,string.len(line) do
            -- get the char
            c = line:sub(x,x)
            
            -- save it off to this point in the maze
            maze[rows][x] = c
            
            -- grow our maze width if necessary
            if x > cols then
                cols = x
            end

            -- note our start position if we find it
            if c == "0" then
                start_row = rows
                start_col = x
            end

            -- if the character is not # or ., then we know
            -- we found another stop we'll have to visit
            if not (c == "#") then
                if not (c == ".") then
                    stops = stops + 1
                end
            end
        end

        -- increment rows
        rows = rows + 1
    end
end

fp:close()

-- rows is really one less since we always increment
rows = rows - 1

-- states, how many different states can there be
-- it depends on the stops, 1 stop can have 2 states (visited or not)
-- 2 stops can have 4 states, etc
-- thus we can represent the state (how many stops we visited) by a number
-- we don't consider 0 a state since we start at a stop (0)
-- so we do the -1
states = (2^stops) - 1

-- create a table to track our states
-- for each x/y, we will have an array of states [1...states]
-- that will get pre-populated with -1
-- meaning we never visited that x/y with that state
-- as we visit an x/y with a given state, we will populate that state
-- in the array with the moves it took to get there
for y=1,rows do
    state[y] = {}
    for x=1,cols do
        state[y][x] = {}
        for z=1,states do
            state[y][x][z] = -1
        end
    end
end

-- flags, found part1 or part 2 solution
found1 = false
found2 = false
done = false

-- set the moves for our starting location and state to 0
-- 2^0 = 1
state[start_row][start_col][1] = 0

-- until we set done
while not done do

    -- for every x/y
    for y=1,rows do
        for x=1,cols do
            -- if this x/y is a wall, we'll skip it
            if not (maze[y][x] == "#") then
                -- for every possible state at this x/y
                for z=1,states do
                    -- if this state is the move count we are currently on
                    if state[y][x][z] == moves then

                        -- if we haven't solved part 1, but our state indicates
                        -- we've visited every stop
                        if not found1 then
                            if z == (states) then
                                print ("part 1", moves)
                                found1 = true
                            end
                        end

                        -- if we haven't solved part 2, but our state indicates
                        -- we've visited every stop and are back to our start position
                        if not found2 then
                            if (z == states) and (x == start_col) and (y == start_row) then
                                print ("part 2", moves)
                                found2 = true
                                done = true
                            end
                        end

                        -- try each move to adjacent cells
                        checkMove(y-1,x,z)
                        checkMove(y+1,x,z)
                        checkMove(y,x-1,z)
                        checkMove(y,x+1,z)
                    end
                end
            end
        end
    end

    -- go on to next move
    moves = moves + 1
end
