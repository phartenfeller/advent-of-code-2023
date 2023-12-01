with only_nums as (
  select line_no
         -- remove all non numeric characters
       , regexp_replace(line_str, '[^0-9]', '') as line
    from aoc_input
   where day = 1 
     and key = '1'
   order by line_no
), row_res as (
  select line_no
         -- concat first and last character, convert res to number
       , to_number(substr(line, 1, 1) || substr(line, -1, 1)) as row_res
    from only_nums
)
-- sum up all row results
select sum(row_res) from row_res
;
