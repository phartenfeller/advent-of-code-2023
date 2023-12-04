
 
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
        , case 
              when validate_conversion(chr as number) = 1 then 1
              else null
           end as adj_relev_star
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
          sum(adj_count) as adj_count,
          min(x) as grp_start,
          max(x) as grp_end,
          min(y) as y
  from group_ids
  group by groupid
  ), chrs_groups as (
 select c.y, c.x,
       c.line_str, c.chr
       , gp.grp
  from cleaned c
  left join group_res gp
    on c.adj_relev_star is not null
   and c.y = gp.y
   and c.x between gp.grp_start and gp.grp_end
  where c.adj_relev_star is not null or c.chr = '*'
  )
 -- select * from chrs_groups;
  
  , star_grid as (
  select * from chrs_groups
  model
  dimension by (x, y)
  measures (
    chr,
    grp,
    line_str,
    0 as adj_count_star
  )
  ignore nav
  rules(
    adj_count_star[any, any] =
    count(distinct grp)[
          x between cv() - 1 and cv() + 1
        , y between cv() - 1 and cv() + 1
      ] 
  )
  ), gear as (
  select * 
    from star_grid
   where chr = '*'
    and adj_count_star = 2
  ), gear_groups as (
  select g.x
  , g.y
  , gr.grp
     , row_number () over (partition by g.x, g.y order by gr.y) as gear_sort
   from gear g
  join group_res gr
    on 1 =1
    and (
            g.x between gr.grp_start and gr.grp_end
        or  g.x -1 between gr.grp_start and gr.grp_end
        or  g.x + 1 between gr.grp_start and gr.grp_end
        )
    and g.y between gr.y -1 and gr.y +1
  ), gear_res as (
  select y, x, gear_sort, to_number(grp) * to_number(lead(grp) over (order by y, x, gear_sort)) as gear_res
from gear_groups
)
select sum(gear_res)
from gear_res where gear_sort  = 1
;
