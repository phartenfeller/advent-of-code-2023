create table aoc_input (
  day integer not null
, key varchar2(255 char) not null
, line_no integer not null
, line_str varchar2(4000 char) not null
, constraint aoc_input_pk primary key (day, key, line_no)
);

-- sample insert
begin
  insert into aoc_input
    (day, key, line_no, line_str)
  with x as (
    select :bind as data from dual
  )
  select 1
       , 'INPUT' -- or something like 'SAMPLE1'
       , rownum
       , column_value
    from x
       , apex_string.split(x.data, chr(10));

  commit;
end;
/
