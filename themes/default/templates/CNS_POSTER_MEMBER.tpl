<a href="{PROFILE_URL*}" data-focus-activate-tooltip="['{POSTER_DETAILS;~*}','auto','{$IMG;*,icons/48x48/menu/social/members}',null,null,true{+START,IF,{$NOT,{ONLINE}}},true{+END}]" data-mouseover-activate-tooltip="['{POSTER_DETAILS;~*}','auto','{$IMG;*,icons/48x48/menu/social/members}',null,null,true{+START,IF,{$NOT,{ONLINE}}},true{+END}]" data-blur-deactivate-tooltip class="fancy-user-link">{+START,IF_PASSED_AND_TRUE,HIGHLIGHT_NAME}<em>{+END}{$DISPLAYED_USERNAME*,{POSTER_USERNAME}}{+START,IF_PASSED_AND_TRUE,HIGHLIGHT_NAME}</em>{+END}</a>
