{$SET,RAND_ID_PULSE,rand{$RAND}}

{$REQUIRE_JAVASCRIPT,pulse}<span class="pulse_wave" id="pulse_wave_{$GET,RAND_ID_PULSE}">{CONTENT}</span><script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		window['pulse_wave_{$GET,RAND_ID_PULSE}']=[0,'{MAX_COLOR;/}','{MIN_COLOR;/}',{SPEED%},[]];
		window.setInterval(function() { process_wave(document.getElementById('pulse_wave_{$GET,RAND_ID_PULSE}')); },window[document.getElementById('pulse_wave_{$GET,RAND_ID_PULSE}').id][3]);
	});
//]]></script>
