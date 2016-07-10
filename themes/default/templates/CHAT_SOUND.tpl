<script>
// <![CDATA[
	function prepare_chat_sounds()
	{
		if (typeof window.prepared_chat_sounds!='undefined') return;
		window.prepared_chat_sounds=true;

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
	}
// ]]>
</script>
