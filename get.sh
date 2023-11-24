#!/bin/sh
get_author()
{
  echo $(cmus-remote -Q | awk '/^tag (artist)/ {print substr($0, index($0, $3))}')
}

get_song()
{
  echo $(cmus-remote -Q | awk '/^tag (title)/ {print substr($0, index($0, $3))}' | xargs echo)
}

duration()
{
    position_total=$(cmus-remote -Q | grep position | awk '{print $2}')

  position_result=$(echo "scale=2; $position_total/60" | bc)
  position_integer_part=$(echo $position_result | cut -d'.' -f1)
  position_decimal_part="0.$(echo $position_result | cut -d'.' -f2)"
  position_new_seconds=$(echo "scale=2; $position_decimal_part*60" | bc)
  nnn=$(printf "%.0f" $position_new_seconds)
  
  
  ## Duration
  total=$(cmus-remote -Q | grep duration | awk '{print $2}')
  result=$(echo "scale=2; $total/60" | bc)
  integer_part=$(echo $result | cut -d'.' -f1)
  decimal_part="0.$(echo $result | cut -d'.' -f2)"
  new_seconds=$(echo "scale=2; $decimal_part*60" | bc)
  new_seconds_=$(printf "%.0f" $new_seconds)
  if [[ "$new_seconds_" -lt 10 ]]; then
    if [[ "$nnn" -lt 10 ]]; then
      position_real_ns=$(printf "0%.0f" $position_new_seconds)
      real_ns=$(printf "0%.0f" $new_seconds)
      echo "(0$position_integer_part:$position_real_ns / 0$integer_part:$real_ns)"
    else
      position_real_ns=$(printf "%.0f" $position_new_seconds)
      real_ns=$(printf "0%.0f" $new_seconds)
      echo "($position_integer_part:$position_real_ns / $integer_part:$real_ns)"
    fi
  else
    position_real_ns=$(printf "%.0f" $position_new_seconds)
    if [[ "$position_real_ns" -lt 10 ]]; then
      real_ns=$(printf "%.0f" $new_seconds)
      if [[ "$position_integer_part" -eq 0 ]]; then
        if [[ "$position_real_ns" -eq 0 ]]; then
          echo "(0:00 / $integer_part:$real_ns)"
        else
          echo "(0$position_integer_part:0$position_real_ns / $integer_part:$real_ns)"
        fi
      else 
        echo "($position_integer_part:0$position_real_ns / $integer_part:$real_ns)"
      fi
    else
      position_real_ns=$(printf "%.0f" $position_new_seconds)
      if [[ "$position_real_ns" -eq 0 ]]; then exit 2; fi
      real_ns=$(printf "%.0f" $new_seconds)
      if [[ "$position_integer_part" -eq 0 ]]; then
        echo "(0$position_integer_part:$position_real_ns / $integer_part:$real_ns)"
      else 
        echo "($position_integer_part:$position_real_ns / $integer_part:$real_ns)"
      fi
    fi
  fi
}

if [[ "$1" == "song" ]];    then get_song  | tr -d '\n';  fi
if [[ "$1" == "author" ]];  then get_author| tr -d '\n';  fi
if [[ "$1" == "duration" ]]; then duration | tr -d '\n';  fi

# echo "$(get_song) by $(get_author)"
# echo -n "$(duration)"