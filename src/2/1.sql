with max_draws as (
  select line_no
       , (select max(to_number(column_value)) from table(apex_string.grep(line_str, '([0-9]+) green', 'i', '1') ) ) as green
       , (select max(to_number(column_value)) from table(apex_string.grep(line_str, '([0-9]+) blue', 'i', '1') ) ) as blue
       , (select max(to_number(column_value)) from table(apex_string.grep(line_str, '([0-9]+) red', 'i', '1') ) ) as red
       , line_str
    from aoc_input
   where day = 2 
     and key = 'INPUT'
   order by line_no
), possible_games as (
  select *
    from max_draws
   where red <= 12
     and green <= 13
     and blue <= 14
)
select sum(line_no)
from possible_games
;
