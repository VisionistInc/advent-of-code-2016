	program sol
	implicit none
	character(len=100) buffer
	integer pos, i, j, ios
	integer(8), dimension(:), allocatable :: first
	integer(8), dimension(:), allocatable :: last
	integer(8) lil, big, total, earliest

	! count how many lines in the file
	open(99, file="input")
	i = 0
	do
		read(99, *, IOSTAT=ios) buffer
		if (ios < 0) exit
		i = i + 1
	end do
	rewind(99)

	! allocate array based on lines
	allocate(first(i))
	allocate(last(i))

	! read in data
	do 50 j=1,i
		read(99, *) buffer
		pos = index(buffer, "-")
		read(buffer(1:pos-1), *) first(j)
		read(buffer(pos+1:), *) last(j)
50	continue

	! sort the data
	do 100 j=1,i
		! find the lowest entry on the list
		pos = low(first, j, i)

		! do the swap
		lil = first(pos)
		big = last(pos)
		first(pos) = first(j)
		last(pos) = last(j)
		first(j) = lil
		last(j) = big
100	continue

	! solve the problem
	total = 0
	big = last(1)
	earliest = -1

	do 200 j=1,i
		if (first(j) > big+1) then
			total = total + (first(j) - big - 1)
			if (earliest == -1) then
				earliest = big+1
			end if
		end if
		if (last(j) > big) then
			big = last(j)
		end if
200	continue

	print *,"Earliest at: ", earliest
	print *,"Total open:  ", total

	! functions go below
	contains

	! find the smallest
	integer function low(firsts, start, num)
	integer(8), dimension(:), allocatable :: firsts
	integer num, x, start

	low = start

	do 300 x=start,num
		if (firsts(x) < firsts(low)) low = x
300	continue

	return
	end function low

	end program sol
