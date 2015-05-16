{+START,IF,{$NEQ,{I},0}}<a{+START,IF_NON_EMPTY,{WIDTH}} width="{WIDTH*}"{+END}{+START,IF_NON_EMPTY,{HEIGHT}} height="{HEIGHT*}"{+END} rel="lightbox" href="{URL*}">{+END}<img src="{THUMB_URL*}" alt="{!IMAGE}" />{+START,IF,{$NEQ,{I},0}}</a>{+END}

