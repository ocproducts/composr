{$REQUIRE_JAVASCRIPT,charts}

<canvas id="chart_{ID%}"{+START,IF_NON_EMPTY,{WIDTH}} width="{WIDTH*}"{+END}{+START,IF_NON_EMPTY,{HEIGHT}} height="{HEIGHT*}"{+END}></canvas>

<script {$CSP_NONCE_HTML}>
	window.addEventListener('load',function () {
		var ctx = document.getElementById('chart_{ID%}').getContext('2d');

		var data = {
			labels: [
				{+START,LOOP,DATAPOINTS}
					'{LABEL;/}',
				{+END}
			],
			datasets: [{
				data: [
					{+START,LOOP,DATAPOINTS}
						{
							x: {X%},
							y: {Y%},
						},
					{+END}
				],
				pointBackgroundColor: [
					{+START,LOOP,DATAPOINTS}
						'{$?;/,{$IS_NON_EMPTY,{LABEL}},green,{COLOR}}',
					{+END}
				],
			}],
		};

		var options = {
			{+START,IF_NON_EMPTY,{WIDTH}{HEIGHT}}
				responsive: false,
			{+END}
			legend: {
			    display: false,
			},
			scales: {
				xAxes: [{
					{+START,IF_NON_EMPTY,{X_AXIS_LABEL}}
						scaleLabel: {
							display: true,
							labelString: '{X_AXIS_LABEL;/}',
						}
					{+END}
				}],
				yAxes: [{
					{+START,IF_NON_EMPTY,{Y_AXIS_LABEL}}
						scaleLabel: {
							display: true,
							labelString: '{Y_AXIS_LABEL;/}',
						},
					{+END}
					{+START,IF,{BEGIN_AT_ZERO}}
						ticks: {
							beginAtZero: true,
						},
					{+END}
				}],
			},
			tooltips: {
				callbacks: {
					label: function(tooltipItem, data) {
						var label = data.labels[tooltipItem.index];
						var ret = '';
						if (label != '') {
							ret += label + ': ';
						}
						ret += '(' + tooltipItem.xLabel + ', ' + tooltipItem.yLabel + ')';
						return ret;
					}
				},
			},
			plugins: {
				datalabels: false,
			},
		};

		new Chart(ctx, {
			type: 'scatter',
			data: data,
			options: options,
		});
	});
</script>
