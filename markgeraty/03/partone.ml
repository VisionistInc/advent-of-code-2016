open Str

let make_reader file_name =
  let in_channel = open_in file_name in
  let closed = ref false in
  let read_next_line = fun () ->
    if !closed then
      None
    else
      try
        Some (Scanf.fscanf in_channel "%[^\r\n]\n" (fun x -> x))
      with
        End_of_file ->
          let _ = close_in_noerr in_channel in
          let _ = closed := true in
          None in
  (* returning a handle on this function *)
  read_next_line;;

let test_line line =
  let splitLineList = Str.split (Str.regexp " +") line in
  let splitIntsList = List.map int_of_string splitLineList in
  let sorted = List.sort compare splitIntsList in
  let sumOfTwoSmallest = (List.nth sorted 0) + (List.nth sorted 1) in
  sumOfTwoSmallest > (List.nth sorted 2);;

(* read until done, return 1 if works, 0 if doesn't each time, return total count *)
let count_valid_triangles line_reader =
  let rec reducer counter =
    match line_reader() with
    | Some line ->
      if test_line line then
        reducer (counter + 1)
      else reducer counter
    | None -> counter
  in reducer 0;;


(* kick it all off *)
let () = Printf.printf "%d\n" (count_valid_triangles (make_reader "input.txt"));;
