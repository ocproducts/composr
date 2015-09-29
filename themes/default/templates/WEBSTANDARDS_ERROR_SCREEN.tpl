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
			<li><a href="{IGNORE_URL*}">{!WEBSTANDARDS_IGNORE}</a></li>
			<li><a href="{IGNORE_URL_2*}">{!WEBSTANDARDS_IGNORE_2}</a></li>
			<li><a href="{MESSY_URL*}">{!WEBSTANDARDS_MESSAGE}</a></li>
		</ul>
	{+END}

	<h2>{!CODE}</h2>

	<div class="webstandards_div">
		<table class="map_table autosized_table webstandards_table">
			<tbody>
