<script>
// <![CDATA[
	if (typeof window.soundManager!='undefined')
	{
		window.soundManager.setup({url: get_base_url()+'/data', debugMode: false});

		window.soundManager.onload=function() {
			{+START,LOOP,SOUND_EFFECTS}
				soundManager.createSound('{KEY;/}','{VALUE;/}');
			{+END}
		}
	}
// ]]>
</script>
