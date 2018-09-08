{$REQUIRE_JAVASCRIPT,charts}

<canvas id="chart_{ID%}"{+START,IF_NON_EMPTY,{WIDTH}} width="{WIDTH*}"{+END}{+START,IF_NON_EMPTY,{HEIGHT}} height="{HEIGHT*}"{+END}></canvas>

<script {$CSP_NONCE_HTML}>
	window.addEventListener('load',function () {
		var ctx = document.getElementById('chart_{ID%}').getContext('2d');

		var data = {
			labels : [
				{+START,LOOP,X_LABELS}
					'{_loop_var;/}',
				{+END}
			],
			datasets: [
				{+START,LOOP,DATASETS}
					{
						label: '{LABEL;/}',
						fill: false,
						backgroundColor: '{COLOR;/}',
						borderColor: '{COLOR;/}',
						data: [
							{+START,LOOP,DATA}
								{_loop_var%},
							{+END}
						],
					},
				{+END}
			],
		};

		var options = {
			{+START,IF_NON_EMPTY,{WIDTH}{HEIGHT}}
				responsive: false,
			{+END}
			scales: {
				{+START,IF_NON_EMPTY,{X_AXIS_LABEL}}
					xAxes: [{
						scaleLabel: {
							display: true,
							labelString: '{X_AXIS_LABEL;/}',
						}
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

			plugins: {
				{+START,IF,{$NOT,{SHOW_DATA_LABELS}}}
					datalabels: false,
				{+END}
				{+START,IF,{SHOW_DATA_LABELS}}
					datalabels: {
						backgroundColor: function(context) {
							return context.dataset.backgroundColor;
						},
						borderRadius: 4,
						color: '#FFFFFF',
						font: {
							weight: 'bold'
						},
					},
				{+END}
			},
		};

		new Chart(ctx, {
			type: 'line',
			data: data,
			options: options,
		});
	});
</script>
