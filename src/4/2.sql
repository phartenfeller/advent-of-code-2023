declare
 type t_num_map is table of pls_integer index by pls_integer;
 l_ticket_count_map t_num_map;
 
 l_curr_ticket_count pls_integer := 0;
 l_all_ticket_count pls_integer := 0;
 l_tmp pls_integer;
begin
  for rec in (
  with num_split as (
  select aoc_input.*
       , regexp_substr(line_str, ': ([[0-9 ]+) \|', 1, 1, null, 1) as own_nums
       , regexp_substr(line_str, '\| ([[0-9 ]+)', 1, 1, null, 1) as winning_nums
      from aoc_input 
     where day = 4 
       and key = 'INPUT'
  )
  select line_no
       , ( select count(*) 
             from table(apex_string.split_numbers(own_nums, ' '))
            where column_value member of apex_string.split_numbers(winning_nums, ' ')
         ) as wins
    from num_split
   order by line_no
  )
  loop
    if l_ticket_count_map.exists(rec.line_no) then
      l_curr_ticket_count := l_ticket_count_map(rec.line_no);
    else
      l_ticket_count_map(rec.line_no) := 1;
      l_curr_ticket_count := 1;
    end if;
    
    l_all_ticket_count := l_all_ticket_count + l_curr_ticket_count;
  
    dbms_output.put_line(
      apex_string.format(
        'Ticket %0 (%1x): %2 wins, sum: %3'
       , rec.line_no
       , l_curr_ticket_count
       , rec.wins
       , l_all_ticket_count
    ));
    
    for i in 1..rec.wins
    loop
      if l_ticket_count_map.exists(rec.line_no + i) then
        l_tmp := l_ticket_count_map(rec.line_no + i);
        l_ticket_count_map(rec.line_no + i) := l_tmp + l_curr_ticket_count;
      else
        l_ticket_count_map(rec.line_no + i) := l_curr_ticket_count + 1;
      end if;
    end loop;
  end loop;

  dbms_output.put_line(apex_string.format('Result: %0', l_all_ticket_count));
end;
/
