{+START,IF_NON_EMPTY,{TITLE}}
<section class="box box___block_main_google_map_users inline_block"><div class="box_inner">
	<h3>{TITLE*}</h3>
{+END}

    {$SET,google_map_key,{$CONFIG_OPTION,google_map_key}}
    {$SET,username,{$USERNAME,{$MEMBER},1}}

	<div id="map_canvas" data-require-javascript="user_mappr"
		 data-tpl="blockMainGoogleMapUsers" data-tpl-params="{+START,PARAMS_JSON,google_map_key,username,DATA,USERNAME_PREFIX,G_DEFAULT_ICON,LATITUDE,LONGITUDE,ZOOM,CLUSTER,CENTER,GEOLOCATE_USER,SET_COORD_URL,REGION}{_*}{+END}"
		 style="width: {WIDTH}; height: {HEIGHT}"></div>

{+START,IF_NON_EMPTY,{TITLE}}
</div></section>
{+END}
