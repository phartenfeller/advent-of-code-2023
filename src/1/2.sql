-- problem "eightwo" should be "82" so we can't just replace all digits
-- solution helper function that checks for digits for each character and adds them to the result string
CREATE OR REPLACE FUNCTION day1_replace_digits(pi_str VARCHAR2) RETURN VARCHAR2 IS
    l_temp_str   VARCHAR2(4000);
    l_replaced_str VARCHAR2(4000) := '';
BEGIN
    dbms_output.put_line(pi_str);
    for i in 1 .. length(pi_str)
    loop
      l_temp_str := substr(pi_str, i);
      
      case
        when l_temp_str like 'one%' then
          l_replaced_str := l_replaced_str || '1';
        when l_temp_str like 'two%' then
          l_replaced_str := l_replaced_str || '2';
        when l_temp_str like 'three%' then
          l_replaced_str := l_replaced_str || '3';
        when l_temp_str like 'four%' then
          l_replaced_str := l_replaced_str || '4';
        when l_temp_str like 'five%' then
          l_replaced_str := l_replaced_str || '5';
        when l_temp_str like 'six%' then
          l_replaced_str := l_replaced_str || '6';
        when l_temp_str like 'seven%' then
          l_replaced_str := l_replaced_str || '7';
        when l_temp_str like 'eight%' then
          l_replaced_str := l_replaced_str || '8';
        when l_temp_str like 'nine%' then
          l_replaced_str := l_replaced_str || '9';
        else
          l_replaced_str := l_replaced_str || substr(pi_str, i, 1);
      end case;
      
    end loop;

    dbms_output.put_line(l_replaced_str);
    RETURN l_replaced_str;
END day1_replace_digits;
/


with digit_str as (
  select line_no
       , day1_replace_digits(line_str) as line_str
       , line_str as orig
    from aoc_input
   where day = 1 
     and key = '1'
), only_nums as (
  select line_no
         --remove all non-digits
       , regexp_replace(line_str, '[^0-9]', '') as line
       , line_str
       , orig
    from digit_str
   order by line_no
), row_res as (
  select line_no
       , to_number(substr(line, 1, 1) || substr(line, -1, 1)) as row_res
       , line_str
       , orig
    from only_nums
)
select sum(row_res) from row_res
;
