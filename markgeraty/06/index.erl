- module(index).
- export([start/0]).

%% http://stackoverflow.com/questions/2475270/how-to-read-the-contents-of-a-file-in-erlang
readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try get_all_lines(Device)
      after file:close(Device)
    end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> Line ++ get_all_lines(Device)
    end.

create_tokens(Line) ->
  string:tokens(Line, "").

start() ->
  lines = string:tokens(readlines("sample.txt"), "\n"),
  array:map(create_tokens, lines).
