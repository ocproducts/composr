<script>
// <![CDATA[
	if (typeof window.soundManager!='undefined')
	{
		add_event_listener_abstract(window,'real_load',function () {
			window.soundManager.setup({url: get_base_url()+'/data', debugMode: false, preferFlash : false, html5Only : true});

			soundManager.onload=function() {
				{+START,LOOP,SOUND_EFFECTS}
					soundManager.createSound('{KEY;/}','{VALUE;/}');
				{+END}
			}
		} );
	}
// ]]>
</script>
