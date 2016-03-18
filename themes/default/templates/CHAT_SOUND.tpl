<script>
// <![CDATA[
	add_event_listener_abstract(window,'load',function () {
		if (typeof window.soundManager!='undefined')
		{
			window.soundManager.setup({
				url: get_base_url()+'/data',
				debugMode: false,
				onready: function() {
					{+START,LOOP,SOUND_EFFECTS}
						window.soundManager.createSound('{KEY;/}','{VALUE;/}');
					{+END}
				}
			});
		}
	} );
// ]]>
</script>
