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
), power as (
  select max_draws.*, green * blue * red as pwr
  from max_draws
)
select sum(pwr) from power
;
