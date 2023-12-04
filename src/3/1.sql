 with max_len as (
 select max(length(line_str)) ml
   from aoc_input 
   where day = 3 
     and key = 'INPUT'
   order by line_no
 ), data as (
  select aoc_input.*
       , ml
    from aoc_input 
    cross join max_len
   where day = 3 
     and key = 'INPUT'
  ), char_cols as (
  select line_no y
       , char_no x
       , line_str
       , substr(line_str, char_no, 1) chr
       from data
  cross join lateral(
      select level char_no
        from dual
    connect by level <= ml
    ) block_rows
  order by line_no, char_no
  ), cleaned as (
    select char_cols.*
         , case 
              when chr = '.' then null
              when validate_conversion(chr as number) = 1 then null
              else chr
           end as adj_relev
    from char_cols
  ), grid as (
  select * from cleaned
  model
  dimension by (x, y)
  measures (
    chr,
    adj_relev,
    line_str,
    0 as adj_count
  )
  ignore nav
  rules(
    adj_count[any, any] =
    count(adj_relev)[
          x between cv() - 1 and cv() + 1
        , y between cv() - 1 and cv() + 1
      ]
  )
  ), grouped_almost as (
  select grid.*
        , case when lag(x) over (order by y,x) = x - 1 
            then 1 
            else 0 
          end as grp
          from grid
  where chr is not null and validate_conversion(chr as number) = 1
  order by y,x
  ), group_ids as (
  select grouped_almost.*
     , SUM(CASE WHEN GRP = 0 THEN 1 ELSE 0 END) OVER (ORDER BY Y, X) AS GroupID
  from grouped_almost
  ), group_res as (
  select  to_number(LISTAGG(CHR, '') WITHIN GROUP (ORDER BY Y, X)) AS grp,
          sum(adj_count) as adj_count
  from group_ids
  group by groupid
  )
  select sum(grp)
    from group_res
    where adj_count > 0
  ;
