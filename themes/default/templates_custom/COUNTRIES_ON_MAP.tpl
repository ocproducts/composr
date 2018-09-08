<script {$CSP_NONCE_HTML} src="https://www.gstatic.com/charts/loader.js"></script>

<script {$CSP_NONCE_HTML}>
	google.charts.load('current', {
		'packages': ['geochart'],
		'mapsApiKey': '{API_KEY;/}',
	});
	google.charts.setOnLoadCallback(drawRegionsMap);

	function drawRegionsMap() {
		var data = new google.visualization.DataTable();
		data.addColumn('string', 'Country');
		data.addColumn('number', '{INTENSITY_LABEL;/}');
		data.addColumn({type: 'string', role: 'tooltip'});
		data.addRows([
			{+START,LOOP,DATA}
				['{REGION;/}', {INTENSITY%}, '{DESCRIPTION;/}'],
			{+END}
		]);

		var options = {
			{+START,IF,{SHOW_LABELS}}
				displayMode: 'text',
			{+END}
			datalessRegionColor: '#ffffff',
			colorAxis: {
				colors: [
					{+START,LOOP,COLOR_POOL}
						'{_loop_var;/}',
					{+END}
				],
			},
		};

		var chart = new google.visualization.GeoChart(document.getElementById('{ID%}'));

		chart.draw(data, options);
	}
</script>

<div id="{ID%}" style="width: {WIDTH*}; height: {HEIGHT*}"></div>
