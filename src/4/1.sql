with num_split as (
select aoc_input.*
     , regexp_substr(line_str, ': ([[0-9 ]+) \|', 1, 1, null, 1) as own_nums
     , regexp_substr(line_str, '\| ([[0-9 ]+)', 1, 1, null, 1) as winning_nums
    from aoc_input 
   where day = 4 
     and key = 'INPUT'
), wins as (
select line_no
     , ( select count(*) 
           from table(apex_string.split_numbers(own_nums, ' '))
          where column_value member of apex_string.split_numbers(winning_nums, ' ')
       ) as cnt
  from num_split
), scores as (
select wins.* , case when cnt = 0 then 0 else power(2, cnt-1) end as score
from wins
)
select sum(score) from scores
;
