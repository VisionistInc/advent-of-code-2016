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
  let split_line_list = Str.split (Str.regexp " +") line in
  let split_ints_list = List.map int_of_string split_line_list in
  let sorted = List.sort compare split_ints_list in
  let sum_of_two_smallest = (List.nth sorted 0) + (List.nth sorted 1) in
  sum_of_two_smallest > (List.nth sorted 2);;

let create_line_accumulator line_reader =
  let rec accumulate_lines line_list left_to_read =
    if left_to_read == 0 then
      line_list
    else
      match line_reader() with
      | Some line -> accumulate_lines (List.append line_list [line]) (left_to_read - 1)
      | None -> []
  (* return a handle on this recursive function *)
  (* call: accumulate_lines [] 3 *)
  in accumulate_lines;;

let rec transpose m =
  assert (m <> []);
  if List.mem [] m then
    []
  else
    List.map List.hd m :: transpose (List.map List.tl m);;

let test_valid list =
  let sum_of_two_smallest = (List.nth list 0) + (List.nth list 1) in
  sum_of_two_smallest > (List.nth list 2);;

let valid_cols three_lines =
  let matrix = List.map (Str.split (Str.regexp " +")) three_lines in
  let int_matrix = List.map (List.map int_of_string) matrix in
  let transposed = transpose int_matrix in
  let sorted = List.map (List.sort compare) transposed in
  let rec reducer list valid_count =
    if List.length list == 0 then
      valid_count
    else if test_valid (List.hd list) then
      reducer (List.tl list) (valid_count + 1)
    else
      reducer (List.tl list) valid_count
    in reducer sorted 0;;

(* read three lines at a time ... check for None in result to get to end *)
(* perform the same test, but column-wise across three lines *)
let count_valid_triangles read_lines =
  let rec reducer counter =
    let three_lines = read_lines [] 3 in
    if (List.length three_lines) == 0 then
      counter
    else
      reducer (counter + (valid_cols three_lines))
  in reducer 0;;

(* kick it all off *)
let () = Printf.printf "%d\n" (count_valid_triangles (create_line_accumulator (make_reader "input.txt")));;
