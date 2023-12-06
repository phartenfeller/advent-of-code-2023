CREATE GLOBAL TEMPORARY TABLE day_5_maps (
  map_type     VARCHAR2(20),
  range_start  INTEGER,
  range_end    INTEGER,
  modifier     INTEGER,
  constraint  day_5_maps_pk primary key (map_type, range_start),
  constraint  map_type_ck check (map_type in 
    ('SOIL', 'FERTILIZER', 'WATER', 'LIGHT', 'TEMPERATURE', 'HUMIDITY', 'LOCATION')
  )
)  on commit delete rows;

declare
  c_day constant integer := 5;
  c_key constant varchar2(20) := 'INPUT';

  c_soil constant varchar2(20) := 'SOIL';
  c_fertilizer constant varchar2(20) := 'FERTILIZER';
  c_water constant varchar2(20) := 'WATER';
  c_light constant varchar2(20) := 'LIGHT';
  c_temperature constant varchar2(20) := 'TEMPERATURE';
  c_humidity constant varchar2(20) := 'HUMIDITY';
  c_location constant varchar2(20) := 'LOCATION';
  
  l_seeds apex_t_number;
  l_res number;

  function get_seeds
    return apex_t_number
  as
    l_ret apex_t_number;
  begin
    select apex_string.split_numbers(
              regexp_substr(line_str, 'seeds: ([0-9 ]+)', 1, 1, null, 1)
              , ' '
           )
      into l_ret
      from aoc_input 
     where day = c_day
       and key = c_key
       and line_str like 'seeds:%'
    ;
    return l_ret;
  end get_seeds;


  procedure init_single_map (
    pi_type in varchar2
  )
  as
    l_line_no_after_str varchar2(100);
    l_line_no_after number;
    l_line_no_before_str varchar2(100);
    l_line_no_before number;

    l_num_arr apex_t_number;

    l_range_start number;
    l_range_end number;
    l_modifier number;
  begin
    case pi_type
      when c_soil then
        l_line_no_after_str := 'seed-to-soil';
        l_line_no_before_str := 'soil-to-fertilizer';
      when c_fertilizer then
        l_line_no_after_str := 'soil-to-fertilizer';
        l_line_no_before_str := 'fertilizer-to-water';
      when c_water then
        l_line_no_after_str := 'fertilizer-to-water';
        l_line_no_before_str := 'water-to-light';
      when c_light then
        l_line_no_after_str := 'water-to-light';
        l_line_no_before_str := 'light-to-temperature';
      when c_temperature then
        l_line_no_after_str := 'light-to-temperature';
        l_line_no_before_str := 'temperature-to-humidity';
      when c_humidity then
        l_line_no_after_str := 'temperature-to-humidity';
        l_line_no_before_str := 'humidity-to-location';
      when c_location then
        l_line_no_after_str := 'humidity-to-location';
        l_line_no_before_str := null;
      else
        dbms_output.put_line('Unhandeled type: ' || pi_type);
        raise no_data_found;
    end case;

    dbms_output.put_line(
      apex_string.format(
        'l_line_no_after_str = %s, l_line_no_before_str = %s'
      , l_line_no_after_str
      , l_line_no_before_str
      )
    );

    select line_no + 1
      into l_line_no_after
      from aoc_input
     where day = c_day
       and key = c_key
       and line_str like l_line_no_after_str || '%';

    if l_line_no_before_str is not null then
      select line_no - 1
        into l_line_no_before
        from aoc_input
       where day = c_day
         and key = c_key
         and line_str like l_line_no_before_str || '%';
    else
      l_line_no_before := 999999999;
    end if;
    
    dbms_output.put_line(
      apex_string.format(
        'l_line_no_after = %s, l_line_no_before = %s'
      , l_line_no_after
      , l_line_no_before
      )
    );

    for rec in (
      select line_no, line_str
        from aoc_input
       where day = c_day
         and key = c_key
         and line_no between l_line_no_after and l_line_no_before
    )
    loop  
      l_num_arr := apex_string.split_numbers(rec.line_str, ' ');

      l_range_start := l_num_arr(2);
      l_range_end := l_num_arr(2) + l_num_arr(3) - 1;
      l_modifier := l_num_arr(1) - l_num_arr(2);

      dbms_output.put_line(
        apex_string.format(
          '%s (%s): %s - %s, modifier: %s'
        , pi_type
        , rec.line_no
        , l_range_start
        , l_range_end
        , l_modifier
        )
      );

      insert into day_5_maps (
        map_type
      , range_start
      , range_end
      , modifier
      ) values (
        pi_type
      , l_range_start
      , l_range_end
      , l_modifier
      );
    end loop;
    
  end init_single_map;


  procedure init_maps
  as
  begin
    init_single_map(c_soil);
    init_single_map(c_fertilizer);
    init_single_map(c_water);
    init_single_map(c_light);
    init_single_map(c_temperature);
    init_single_map(c_humidity);
    init_single_map(c_location);
  end init_maps;

  function apply_modifier (
    pi_type    in varchar2
  , pi_numbers in apex_t_number
  )
    return apex_t_number
  as
    l_mod number;
    l_mod_numbers apex_t_number := apex_t_number();
  begin
    for i in 1 .. pi_numbers.count
    loop
      begin
        select modifier
          into l_mod
          from day_5_maps
        where map_type = pi_type
          and range_start <= pi_numbers(i)
          and range_end >= pi_numbers(i)
        ;
      exception
        when no_data_found then
          l_mod := 0;
        when others then
          raise;
      end;

      apex_string.push(l_mod_numbers, pi_numbers(i) + l_mod);
    end loop;

    return l_mod_numbers;
  end apply_modifier;
begin
  rollback;
  l_seeds := get_seeds;
  init_maps();

  l_seeds := apply_modifier(c_soil, l_seeds);
  l_seeds := apply_modifier(c_fertilizer, l_seeds);
  l_seeds := apply_modifier(c_water, l_seeds);
  l_seeds := apply_modifier(c_light, l_seeds);
  l_seeds := apply_modifier(c_temperature, l_seeds);
  l_seeds := apply_modifier(c_humidity, l_seeds);
  l_seeds := apply_modifier(c_location, l_seeds);

  dbms_output.put_line('All modified: ' || apex_string.join(l_seeds, ', '));

  select min(column_value)
    into l_res
    from table(l_seeds)
  ;

  dbms_output.put_line('Result: ' || l_res);
end;
/
