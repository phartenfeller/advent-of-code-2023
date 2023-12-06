# Notes Day 5

## Part 2

Mapping Ranges for SAMPLE set.

Result mapping table of part1:

```
"MAP_TYPE"      "RANGE_START"  "RANGE_END"  "MODIFIER"
"SOIL"          "98"           "99"         "-48"     
"SOIL"          "50"           "97"         "2"       
"FERTILIZER"    "15"           "51"         "-15"     
"FERTILIZER"    "52"           "53"         "-15"     
"FERTILIZER"    "0"            "14"         "39"      
"WATER"         "53"           "60"         "-4"      
"WATER"         "11"           "52"         "-11"     
"WATER"         "0"            "6"          "42"      
"WATER"         "7"            "10"         "50"      
"LIGHT"         "18"           "24"         "70"      
"LIGHT"         "25"           "94"         "-7"      
"TEMPERATURE"   "77"           "99"         "-32"     
"TEMPERATURE"   "45"           "63"         "36"      
"TEMPERATURE"   "64"           "76"         "4"       
"HUMIDITY"      "69"           "69"         "-69"     
"HUMIDITY"      "0"            "68"         "1"       
"LOCATION"      "56"           "92"         "4"       
"LOCATION"      "93"           "96"         "-37"     
```

Apply Soil:

```
"SOIL"          "98"           "99"         "-48"     
"SOIL"          "50"           "97"         "2"    
```

`0-49 (0 -> 0-40), 50-97 (+2 -> 52-99), 98-99 (-48 -> 50-51), 100+ (0 -> 100-999999999999999)`


Apply Fertilizer:

```
"FERTILIZER"    "15"           "51"         "-15"     
"FERTILIZER"    "52"           "53"         "-15"     
"FERTILIZER"    "0"            "14"         "39" 
```

`0-14 (39 -> 39-53), 15-40 (-15 -> 0-25), 50-51 (-15 -> 35-36), 52-53 (-15 -> 37-38), 54-99 (0 -> 54-99), 100+ (0 -> 100-999999999999999)`

