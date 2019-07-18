{$REQUIRE_JAVASCRIPT,charts}

<canvas id="chart_{ID%}"{+START,IF_NON_EMPTY,{WIDTH}} width="{WIDTH*}"{+END}{+START,IF_NON_EMPTY,{HEIGHT}} height="{HEIGHT*}"{+END}></canvas>

<script {$CSP_NONCE_HTML}>
	window.addEventListener('load',function () {
		var ctx = document.getElementById('chart_{ID%}').getContext('2d');

		var data = {
			datasets: [{
				data: [
					{+START,LOOP,DATAPOINTS}
						{VALUE%},
					{+END}
				],
				backgroundColor: [
					{+START,LOOP,DATAPOINTS}
						'{COLOR;/}',
					{+END}
				],
			}],

			labels: [
				{+START,LOOP,DATAPOINTS}
					'{LABEL;/}',
				{+END}
			],
			tooltips: [
				{+START,LOOP,DATAPOINTS}
					'{TOOLTIP;/}',
				{+END}
			],
		};

		var options = {
			{+START,IF_NON_EMPTY,{WIDTH}{HEIGHT}}
				responsive: false,
			{+END}
			legend: {
				display: false,
			},
			scales: {
				{+START,IF_NON_EMPTY,{X_AXIS_LABEL}}
					xAxes: [{
						scaleLabel: {
							display: true,
							labelString: '{X_AXIS_LABEL;/}',
						},
						ticks: {
							autoSkip: false,
						},
					}],
				{+END}
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
						var tooltip = data.tooltips[tooltipItem.index];
						var ret = '';
						{+START,IF,{$NOT,{SHOW_DATA_LABELS}}}
							ret += data.datasets[0].data[tooltipItem.index];
						{+END}
						if (tooltip != '') {
							if (ret != '') {
								ret += ': ';
							}
							ret += tooltip;
						}
						return ret;
					},
				},
			},

			plugins: {
				{+START,IF,{$NOT,{SHOW_DATA_LABELS}}}
					datalabels: false,
				{+END}
				{+START,IF,{SHOW_DATA_LABELS}}
					datalabels: {
						color: 'white',
						display: function(context) {
							return true;//context.dataset.data[context.dataIndex] > 15;
						},
						font: {
							weight: 'bold'
						},
						formatter: Math.round
					},
				{+END}
			},
		};

		new Chart(ctx, {
			type: 'bar',
			data: data,
			options: options,
		});
	});
</script>
