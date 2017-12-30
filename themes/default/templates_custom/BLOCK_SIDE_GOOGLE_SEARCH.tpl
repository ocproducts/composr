<section class="box box___block_side_google_search"><div class="box_inner">
	{+START,IF_NON_EMPTY,{TITLE}}<h3>{TITLE*}</h3>{+END}

	<div id="cse-search-form">
		<script>
		(function() {
			var cx = '{ID;/}';
			var gcse = document.createElement('script');
			gcse.type = 'text/javascript';
			gcse.async = true;
			gcse.src = 'https://cse.google.com/cse.js?cx=' + cx;
			var s = document.getElementsByTagName('script')[0];
			s.parentNode.insertBefore(gcse, s);
			})();
		</script>
		<gcse:searchbox-only resultsUrl="{$PAGE_LINK*,_SELF:{PAGE_NAME}}"></gcse:searchbox-only>

		<script src="https://www.google.com/jsapi"></script>

		<script>// <![CDATA[
			add_event_listener_abstract(window,'load',function () {
				if (document.getElementById('cse')) // On results page
				{
					var no_search_entered=document.getElementById('no_search_entered');
					if (no_search_entered) no_search_entered.parentNode.removeChild(no_search_entered);
				}

				google.load('search','1',{language:'en'});
				google.setOnLoadCallback(function() {
					var cse_form=document.getElementById('cse-search-form');
					get_elements_by_class_name(cse_form,'gsc-search-box')[0].innerHTML+='{$INSERT_SPAMMER_BLACKHOLE;^/}';
				});
			});
		//]]></script>
	</div>

	{$REQUIRE_CSS,google_search}
</div></section>
