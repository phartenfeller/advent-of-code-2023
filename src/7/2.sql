create or replace function day7_get_hand_rank_part2 (pi_hand in varchar2)
  return number
as
  type t_char_map is table of number index by varchar2(1char);
  l_char_map t_char_map;
  
  l_char varchar2(1 char);
  l_key  varchar2(1 char);
  l_fir_highest number := 0;
  l_sec_highest number := 0;

  l_res_str varchar2(40);
  l_card_value_seq varchar2(20) := '';
  l_joker_count number := 0;

  function get_card_value (pi_char in varchar2)
    return varchar2
  as
  begin
    case pi_char
      when 'A' then
        return '14';
      when 'K' then
        return '13';
      when 'Q' then
        return '12';
      when 'J' then
        return '01';
      when 'T' then
        return '10';
      else
        return '0' || pi_char;
    end case;
  end get_card_value;
begin
  for i in 1..5
  loop
    l_char := substr(pi_hand, i, 1);
    if l_char_map.exists(l_char) then
      l_char_map(l_char) := l_char_map(l_char) + 1;
    elsif l_char = 'J' then
      -- dont put into map
      l_joker_count := l_joker_count + 1;
    else
      l_char_map(l_char) := 1;
    end if;

    l_card_value_seq := l_card_value_seq || get_card_value(l_char);
  end loop;

  dbms_output.put_line(
    apex_string.format(
      'Card value seq for "%s": %s',
      pi_hand,
      l_card_value_seq
    )
  );

  l_key := l_char_map.first;
  while l_key is not null
  loop
    if l_char_map(l_key) > l_fir_highest then
      l_sec_highest := l_fir_highest;
      l_fir_highest := l_char_map(l_key);
    elsif l_char_map(l_key) > l_sec_highest  then
      l_sec_highest := l_char_map(l_key);
    end if;

    l_key := l_char_map.next(l_key);
  end loop;

  if l_joker_count > 0 then
    l_fir_highest := l_fir_highest + l_joker_count;
  end if;

  dbms_output.put_line(
    apex_string.format(
      'l_fir_highest: %s, l_sec_highest: %s',
      l_fir_highest,
      l_sec_highest
    )
  );

  case l_fir_highest
    when 5 then
      l_res_str := '7';
    when 4 then
      l_res_str := '6';
    when 3 then
      if l_sec_highest = 2 then
        l_res_str := '5';
      else
        l_res_str := '4';
      end if;
    when 2 then
      if l_sec_highest = 2 then
        l_res_str := '3';
      else
        l_res_str := '2';
      end if;
    when 1 then
      l_res_str := '1';
    else
      raise no_data_found;
  end case;

  l_res_str := l_res_str || l_card_value_seq;

  dbms_output.put_line(
    apex_string.format(
      'l_res_str %s',
      l_res_str
    )
  );

  return to_number(l_res_str);
end day7_get_hand_rank_part2;
/

with hand_bet as (
select regexp_substr(line_str, '([0-9A-Z]+) [0-9]+', 1, 1, null, 1) as hand
     , to_number(regexp_substr(line_str, '[0-9A-Z]+ ([0-9]+)', 1, 1, null, 1)) as bet
    from aoc_input 
   where day = 7
     and key = 'INPUT'
), scores as (
select hand
     , bet
     , day7_get_hand_rank_part2(hand) as score
     , row_number() over(order by day7_get_hand_rank_part2(hand) asc) as rnk
from hand_bet
order by 4 desc
)
select sum(rnk * bet)
from scores
;
