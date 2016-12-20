program sol;
var
    elves : array of longint;
    num, i : longint;
begin
    num := 3005290;
    setlength(elves, num);
    for i:=0 to (num-1) do
        elves[i] := i+1;

    while num > 1 do
    begin
        if (num mod 2) = 0 then
            for i := 0 to ((num div 2)-1) do
                elves[i] := elves[i*2];

        if (num mod 2) = 1 then
            for i := 0 to ((num div 2)-1) do
                elves[i] := elves[(i*2)+2];

        num := num div 2;
        setlength(elves, num);
    end;
    
    writeln (elves[0]);
end.
