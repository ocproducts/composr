{$REQUIRE_JAVASCRIPT,charts}

<canvas id="chart_{ID%}"{+START,IF_NON_EMPTY,{WIDTH}} width="{WIDTH*}"{+END}{+START,IF_NON_EMPTY,{HEIGHT}} height="{HEIGHT*}"{+END}></canvas>

<script {$CSP_NONCE_HTML}>
	window.addEventListener('load',function () {
		var ctx = document.getElementById('chart_{ID%}').getContext('2d');

		var data = {
			datasets: [{
				data: [
					{+START,LOOP,DATA}
						{VALUE%},
					{+END}
				],
				backgroundColor: [
					{+START,LOOP,DATA}
						'{COLOR;/}',
					{+END}
				],
			}],

			labels: [
				{+START,LOOP,DATA}
					'{LABEL;/}',
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
