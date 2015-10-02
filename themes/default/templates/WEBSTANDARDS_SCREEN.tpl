<div class="{$,{RET},global_middle,}">
	{TITLE}

	{+START,IF_NON_EMPTY,{RETURN_URL}}
		<p class="back_button">
			<a href="{RETURN_URL*}"><img title="{MSG}" alt="{MSG}" src="{$IMG*,icons/48x48/menu/_generic_admin/back}" /></a>
		</p>
	{+END}

	{+START,IF_NON_EMPTY,{MESSY_URL}}
		<ul class="actions_list">
			<li>{!WEBSTANDARDS_MESSAGE,{MESSY_URL*}}</li>
		</ul>
	{+END}

	<div class="webstandards_div">
		<table class="map_table autosized_table webstandards_table">
			<tbody>
