program sol;
var
    elves : array of longint;
    num, i, add, save: longint;
begin
    num := 3005290;
    setlength(elves, num);
    for i:=0 to (num-1) do
        elves[i] := i+1;

    while num > 1 do
    begin
        add := 1;
        save := elves[0];
        for i:=0 to (num-3) do
        begin
            if (i+1) = (num div 2) then
                add := 2;
            elves[i] := elves[i+add];
        end;
        elves[num-2] := save;
        num := num-1;
        setlength(elves,num);
    end;
    
    writeln (elves[0]);
end.
