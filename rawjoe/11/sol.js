/*
 * This stuff is specific to the input
 * We are going to represent the state of everything as a number
 *
 * The lowest bits will make up the microchips
 * The higher bits will make up the corresponding generators
 * The highest bit will make up the floor we are on
 *
 * In part 1, there are 4 floors, so we need two bits to convey
 * the state of each element.
 * 5 microchips + 5 generators + our position == 11 == 22 bits
 *
 * In part two, 4 more items were added, bringing us up to 30 bits.
 *
 * This solutions assumes each microchip has one and only one generator
 */

var NUM_ITEMS = 10;
//var NUM_ITEMS = 14;
 
/* Since there are 4 floors, we need two bits to fully convey state */
var MASK = 0x3;
var MASK_BITS = 2;

/*
 * Our start position;
 * Microchips 1 and 3 are on the second floor,
 * everything else is on the first
 */
var START = 0x000011;
//var START = 0x00000011

/* Our end positions has everything on the 4th floor */
var END = 0x3FFFFF;
//var END = 0x3FFFFFFF;

var MIN_FLOOR = 0;
var MAX_FLOOR = 3;

/******* END OF STUFF TO CHANGE ********/

/*
 * Item bits are used to tell how many bits we need
 * to cover all the items in the state;
 */
var ITEM_BITS = NUM_ITEMS * MASK_BITS;

/* How many bits represent microchips */
var UC_BITS = ITEM_BITS / 2

/* flag to break out of loop */
var notFound = true;

/* how many moves */
var count = 0;

/* our initial state, will be updated with future states */
var now = [START];

/*
 * Tracks states we have seen in the past
 * Since we do a breadth-first search, if we come across
 * a state we've already seen, we don't need to go there
 */
var history = [START];

/*
 * We are going to do a beadth-first search
 * Inital state will return N possible second states
 * Those N will return P possible third states
 * Trimming will occur each round to remove invalid and
 * previously seen states.
 * Eventaully the final state will be seen at it's earliest
 * possibility
 */
 

/* loop until found */
while (notFound)
{
	console.log("Depth " + count + " width " + now.length);

    /*
     * array that will hold all intersting states we can get to
     * from the current states in the array
     */
	var next = [];

    /* while there are some states left at the current level */
	while (now.length > 0)
	{
	    /* get a state */
		var state = now.pop();

        /* if this state is the end state, we are done */
		if (state == END)
		{
			notFound=false;
			break;
		}

        /* get states we can reach from this state */
		var states = getNextStates(state);

        /* for each one of those states we can reach */
		while (states.length > 0)
		{
			var _state = states.pop();

            /* if it's not a valid state (fried microchip), throw away */
			if (!isStateValid(_state))
			{
				continue;
			}

            /* if we've seen that state before, throw away */
			if (history.indexOf(_state) > -1)
			{
				continue;
			}

            /* it's a valid state we haven't seen before */

            /* add to history so we don't process again */
			history.push(_state);

            /* add to next so we branch from it next iteration */
			next.push(_state);
		}
	}

    /* inc moves */
	count++;

    /* now is empty, it takes on all the next moves */
	now = next;
}

console.log("Solved in move " + (count-1));

/*
 * helper function for getting all possible next states
 * from a current states.
 * Does some trimming of illegal states it can easily detect
 */
function getNextStates(cur)
{
    /* this will hold all possible new states */
	var newStates = [];

    /* The current floor is past all the item bits */
	var _floor = cur >> ITEM_BITS;

    /* add all single object moves to array */
	for (var j = 0; j < ITEM_BITS; j+=MASK_BITS)
	{
	    /* get the current item */
		var item = (cur >> j) & MASK;

        /* if the item doesn't exist on the current floor */
		if (item != _floor)
		{
			continue;
		}

        /*
         * We always add or take away 1 to an item
         * And to the floor
         */

        /*
         * 1 << j sets a 1 in the item
         * 1 << ITEM_BITS sets a 1 in the floor
         */
		var add = (1 << j) + (1 << ITEM_BITS);

        /* is going up allowed */
		if (_floor < MAX_FLOOR)
		{
            /* if j is a microchip, is it dangerout to move to new floor */
			if (isFloorBadForUc(cur, j, _floor+1))
			{
				continue;
			}

            /* seems like it could be a valid state, add to array */
			newStates.push(cur+add);
		}

        /* is going down allowed */
		if (_floor > MIN_FLOOR)
		{
            /* if j is a microchip, is it dangerout to move to new floor */
			if (isFloorBadForUc(cur, j, _floor-1))
			{
				continue;
			}

            /* seems like it could be a valid state, add to array */
			newStates.push(cur-add);
		}
	}

    /* now we will look at double object moves */
	for (var j = 0; j < ITEM_BITS; j+=MASK_BITS)
	{
	    /* extract first item */
    	var item1 = (cur >> j) & MASK;

        /* if item1 isn't on floor, move on */
        if (item1 != _floor)
        {
            continue;
        }

	    /* for every item j, we will pair with every item beyond it k */
		for (var k = j+MASK_BITS; k < ITEM_BITS; k+=MASK_BITS)
		{
            /* extract second item */
			var item2 = (cur >> k) & MASK;

            /* if item2 isn't on the floor, move on */
			if (_floor != item2)
			{
				continue;
			}

            /*
             * This check seemed to speed up things a lot
             * if item1 is a microchip, and item 2 is a generator
             * they can only move if they are paired
             *
             * A microchips corresponding generator is the same offset
             * into the generator bits
             */
			if ((j < UC_BITS) && (k >= UC_BITS) && (j != (k - UC_BITS)))
			{
				continue;
			}

            /*
             * 1 << j sets a 1 in the item1
             * 1 << k sets a 1 in the item2
             * 1 << ITEM_BITS sets a 1 in the floor
             */
			var add = (1 << j) + (1 << k) + (1 << ITEM_BITS);

            /* if going up is allowed */
			if (_floor < 3)
			{
                /* 
                 * Only if we are moving 2 microchips do we check
                 * if the move is safe.
                 * Otherwise, a generator may move with a microchip,
                 * which may be ok
                 */
				if ((j < UC_BITS) && (k < UC_BITS))
				{
					if (isFloorBadForUc(cur, j, _floor+1) ||
						isFloorBadForUc(cur, k, _floor+1))
					{
						continue;
					}
				}

                /* seems like it could be a valid state, add to array */
				newStates.push(cur+add);
			}

            /* if going down is allowed */
			if (_floor > 0)
			{
                /* 
                 * Only if we are moving 2 microchips do we check
                 * if the move is safe.
                 * Otherwise, a generator may move with a microchip,
                 * which may be ok
                 */
				if ((j < UC_BITS) && (k < UC_BITS))
				{
					if (isFloorBadForUc(cur, j, _floor-1) ||
						isFloorBadForUc(cur, k, _floor-1))
					{
						continue;
					}
				}

                /* seems like it could be a valid state, add to array */
				newStates.push(cur-add);
			}
		}
	}

    /* return all the new states */
	return newStates;
}

/*
 * Helper for checking if moving microchip will fry it
 */
function isFloorBadForUc(_state, uc, aFloor)
{
    /* flag, to see if floor has generators other than microchips */
	var hasOther = false;

    /* this may get called with index to generator, so we move on */
	if (uc >= UC_BITS)
	{
		return false;
	}

    /* get the generator bits */
	var gens = _state >> UC_BITS;

    /* for each generator */
	for (var s = 0; s < UC_BITS; s+=MASK_BITS)
	{
	    /* get the generator */
		var gen = (gens >> s) & MASK;

        /* if this generatr is on the dest floor */
		if (gen == aFloor)
		{
		    /* if the generator position matched the microchip one */
			if (s == uc)
			{
			    /* it's safe to move, microchip will have generator */
				return false;
			}
            /* indicate that there are oter generators on the floor */
			hasOther = true;
		}
	}

    /*
     * if microchips generator isn't on the floor,
     * it's only safe if no other generator is on the floor
     */
	return hasOther;
}

/* Helper function for determining if a state is valid (no fried chips) */
function isStateValid(_state)
{
    /* for each microchip */
	for (var j = 0; j < UC_BITS; j+=MASK_BITS)
	{
	    /* get out the microchip, and corresponding generator */
		var uc = (_state >> j) & MASK;
		var gen = (_state >> (j+UC_BITS)) & MASK;

        /* if microchip on same floor as generator, all good */
		if (uc == gen)
		{
			continue;
		}

        /* otherwise, need to see if any other generators are with microchip */
		var gens = _state >> UC_BITS;

        /* for each generator */
		for (k = 0; k < UC_BITS; k+=MASK_BITS)
		{
			var gen = (gens >> k) & MASK;

            /* if generator is with microchip, it's fried */
			if (gen == uc)
			{
				return false;
			}
		}
	}

    /* no fried microchips */
	return true;
}
