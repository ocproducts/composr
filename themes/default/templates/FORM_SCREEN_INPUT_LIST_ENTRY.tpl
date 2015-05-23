<option{+START,IF,{SELECTED}} selected="selected"{+END}{+START,IF,{DISABLED}} disabled="disabled"{+END} value="{NAME*}"{+START,IF_NON_EMPTY,{CLASS}} class="{CLASS*}"{+END}>{$TRUNCATE_SPREAD,{$STRIP_TAGS,{TEXT*}},80,0,1}</option>

