import strutils

type Direction = enum
    North, East, South, West

type Loc = object
    x: int
    y: int
    facing: Direction

proc tc_distance[T]( l1, l2: T ): int =
    ## Calculate the taxi cab distance
    abs(l1.x - l2.x) + abs(l1.y - l2.y)

proc move( loc: Loc, input: string ): seq[Loc] =
    ## Return a list of all locations visited
    let direction = input[0]
    let steps = parseInt( input[1..<len(input)] )

    result = newSeq[Loc]()

    var current_loc = loc
    let adjustment = if direction == 'R': 1 else: -1
    current_loc.facing = Direction( (ord(current_loc.facing)+adjustment) %% 4 )

    for i in 1..steps:
        case current_loc.facing:
            of North:
                current_loc.y += 1
            of East:
                current_loc.x += 1
            of South:
                current_loc.y -= 1
            of West:
                current_loc.x -= 1

        result.add( current_loc )


proc main() =
    let input = readFile( "input" )

    var first_found = (x:0, y:0)
    var visit_list = newSeq[tuple[x,y: int]]()

    const origin = Loc( x:0, y:0 )
    var current = origin
    for order in input.split(","):
        let old = current
        echo "At: ", old, " moving:", order
        let just_visited = move( old, order.strip() )

        for step in just_visited:
            let loc_tuple = (x:step.x, y:step.y)
            if loc_tuple in visit_list and first_found == (x:0, y:0):
                first_found = loc_tuple
            else:
                visit_list.add( loc_tuple )

        current = just_visited[^1]
        echo "Now at ", current, "\n"

    echo "Distance: ", tc_distance( origin, current )
    echo "First found: ", first_found, " distance: ", tc_distance( (x:0, y:0), first_found )

when isMainModule:
    main()
