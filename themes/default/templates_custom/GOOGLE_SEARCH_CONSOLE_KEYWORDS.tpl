{$,TODO: Move to .js file #2960}

<div id="ga_{ID*}">
	{+START,INCLUDE,_GOOGLE_TIME_PERIODS}{+END}

	{TABLE}

	<script {$CSP_NONCE_HTML}>
		function reinitialise_ga_{ID/}(days)
		{
			load_snippet('google_search_console&days=' + window.encodeURIComponent(days), null, function(ajax_result) {
				set_inner_html(document.getElementById('ga-{ID;/}'),ajax_result.responseText);
			});
		}

		function initialise_ga_{ID/}(days)
		{
		}
	</script>
</div>
