declare
  c_day number := 6;
  c_key varchar2(10) := 'INPUT';

  l_time number;
  l_dist number;

  l_wins       number := 0;
  l_dist_calc  number;
begin
  select  to_number(
            regexp_replace(
              regexp_substr(line_str, 'Time:[ ]+([0-9 ]+)', 1, 1, null, 1)
              , '[ ]+'
              , '')
          )
  into l_time
  from aoc_input
 where day = c_day
   and key = c_key
   and line_no = 1
  ;

  select  to_number(
            regexp_replace(
              regexp_substr(line_str, 'Distance:[ ]+([0-9 ]+)', 1, 1, null, 1)
              , '[ ]+'
              , '')
          )
  into l_dist
  from aoc_input
 where day = c_day
   and key = c_key
   and line_no = 2
  ;

  dbms_output.put_line('Time: ' || l_time || ' Distance: ' || l_dist);
  l_wins := 0;

  for i in 1..l_time
  loop
    l_dist_calc := i * (l_time - i);

    if l_dist_calc > l_dist
    then
      l_wins := l_wins + 1;
      --dbms_output.put_line('Win: ' || i || ' seconds -> distance: ' || l_dist);
    elsif l_wins > 0 then
      dbms_output.put_line('Lose at: ' || i || ' seconds -> distance: ' || l_dist);
      exit;
    end if;
  end loop;

  dbms_output.put_line('Result: ' || l_wins);
end;
/
