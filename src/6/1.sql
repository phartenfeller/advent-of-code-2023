declare
  c_day number := 6;
  c_key varchar2(10) := 'INPUT';

  l_time_arr apex_t_number;
  l_dist_arr apex_t_number;

  l_wins     pls_integer := 0;
  l_dist     pls_integer;
  l_res      pls_integer := 1;
begin
  select  apex_string.split_numbers(
            regexp_replace(
              regexp_substr(line_str, 'Time:[ ]+([0-9 ]+)', 1, 1, null, 1)
              , '[ ]+'
              , ':')
          , ':')
  into l_time_arr
  from aoc_input
 where day = c_day
   and key = c_key
   and line_no = 1
  ;

  select  apex_string.split_numbers(
            regexp_replace(
              regexp_substr(line_str, 'Distance:[ ]+([0-9 ]+)', 1, 1, null, 1)
              , '[ ]+'
              , ':')
          , ':')
  into l_dist_arr
  from aoc_input
 where day = c_day
   and key = c_key
   and line_no = 2
  ;

  for i in 1..l_time_arr.count
  loop
    dbms_output.put_line('Time: ' || l_time_arr(i) || ' Distance: ' || l_dist_arr(i));
    l_wins := 0;

    for j in 1..l_time_arr(i)
    loop
      l_dist := j * (l_time_arr(i) - j);

      if l_dist > l_dist_arr(i)
      then
        l_wins := l_wins + 1;
        dbms_output.put_line('Win: ' || j || ' seconds -> distance: ' || l_dist);
      elsif l_wins > 0 then
        dbms_output.put_line('Lose at: ' || j || ' seconds -> distance: ' || l_dist);
        exit;
      end if;
    end loop;

    l_res := l_res * l_wins;
  end loop;

  dbms_output.put_line('Result: ' || l_res);
end;
/
