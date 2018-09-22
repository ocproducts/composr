{$,TODO: Move to .js file #2960}

<div id="ga-{ID*}">
	<div id="auth-button-{ID*}"></div>

	{+START,INCLUDE,_GOOGLE_TIME_PERIODS}{+END}

	<div id="timeline-{ID*}"></div>
</div>

<div id="loading-{ID*}" aria-busy="true" class="spaced">
	<div class="ajax-loading vertical-alignment">
		<img src="{$IMG*,loading}" width="{$IMG_WIDTH*,{$IMG,loading}}" height="{$IMG_HEIGHT*,{$IMG,loading}}" title="{!LOADING}" alt="{!LOADING}" />
		<span>{!LOADING}</span>
	</div>
</div>

<script {$CSP_NONCE_HTML}>
	function reinitialise_ga_{ID/}(days)
	{
		window.initialised_ga_{ID/} = false;
		initialise_ga_{ID/}(days);
	}

	window.initialised_ga_{ID/} = false;
	function initialise_ga_{ID/}(days)
	{
		if (window.initialised_ga_{ID/}) return;
		window.initialised_ga_{ID/} = true;

		gapi.analytics.ready(function() {
			var GID = { 'query': { 'ids': 'ga:{PROPERTY_ID%}' } };

			// Authorize the user
			var CLIENT_ID = '{$CONFIG_OPTION;,google_apis_client_id}';
			gapi.analytics.auth.authorize({
				'container': 'auth-button-{ID/}',
				'clientid': CLIENT_ID,
				'serverAuth': { access_token: '{ACCESS_TOKEN;/}' },
			});

			// Create the timeline chart
			var timeline = new gapi.analytics.googleCharts.DataChart({
				'reportType': 'ga',
				'query': {
					'dimensions': '{DIMENSION;/}',
					'metrics': '{+START,LOOP,METRICS}{+START,IF,{$NEQ,{_loop_key},0}},{+END}{_loop_var;/}{+END}',
					'start-date': (typeof days == 'undefined') ? '{DAYS;/}daysAgo' : (days + 'daysAgo'),
					'end-date': 'yesterday',
					{EXTRA/}
				},
				'chart': {
					'type': '{CHART_TYPE;/}',
					'container': 'timeline-{ID/}',
					'options': {'width': '100%'},
				},
			});
			timeline.set(GID).execute();
			timeline.once('success', function() {
				document.getElementById('loading-{ID/}').style.display = 'none';
			});
		});
	}

	{+START,IF,{$NOT,{UNDER_TAB}}}
		initialise_ga_{ID/}();
	{+END}
</script>
