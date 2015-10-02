<div class="{$,{RET},global_middle,}">
	{TITLE}

	{+START,IF_NON_EMPTY,{RETURN_URL}}
		<p class="back_button">
			<a href="{RETURN_URL*}"><img title="{MSG}" alt="{MSG}" src="{$IMG*,icons/48x48/menu/_generic_admin/back}" /></a>
		</p>
	{+END}

	<h2>{!WEBSTANDARDS_ERROR}</h2>

	<ul>
		{ERRORS}
	</ul>

	{+START,IF_NON_EMPTY,{MESSY_URL}}
		<h2>{!ACTIONS}</h2>

		<ul>
			<li>{!WEBSTANDARDS_IGNORE,{IGNORE_URL*}}</li>
			<li>{!WEBSTANDARDS_IGNORE_2,{IGNORE_URL_2*}}</li>
			<li>{!WEBSTANDARDS_MESSAGE,{MESSY_URL*}}</li>
		</ul>
	{+END}

	<h2>{!CODE}</h2>

	<div class="webstandards_div">
		<table class="map_table autosized_table webstandards_table">
			<tbody>
