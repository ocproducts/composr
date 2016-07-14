{$REQUIRE_CSS,modern_tabs}

{$SET,name_set_elsewhere,1}

<div class="vcard member_profile_screen" itemscope="itemscope" itemtype="http://schema.org/ProfilePage">
	{TITLE}

	<!-- Member: #{MEMBER_ID%} -->

	{+START,IF,{$GT,{TABS},1}}
		<div class="modern_tabs">
			<div class="modern_tab_headers" role="tablist">
				{+START,LOOP,TABS}
					<div id="t_{TAB_CODE*}"{+START,IF,{TAB_FIRST}} class="tab_active{+END}">
						<a aria-controls="g_{TAB_CODE*}" role="tab" href="#" onclick="event.returnValue=false; select_tab('g','{TAB_CODE;*}'); return false;">{+START,IF_NON_EMPTY,{TAB_ICON}}<img alt="" src="{$IMG*,icons/24x24/{TAB_ICON}}" srcset="{$IMG*,icons/48x48/{TAB_ICON}} 2x" /> {+END}<span>{TAB_TITLE*}</span></a>
					</div>
				{+END}
			</div>
			<div class="modern_tab_bodies">
				{+START,LOOP,TABS}
					<div aria-labeledby="t_{TAB_CODE*}" role="tabpanel" id="g_{TAB_CODE*}" style="display: {$?,{$OR,{TAB_FIRST},{$NOT,{$JS_ON}}},block,none}">
						<a id="tab__{TAB_CODE*}"></a>

						{+START,IF_PASSED,TAB_CONTENT}
							{TAB_CONTENT}
						{+END}

						{+START,IF_NON_PASSED,TAB_CONTENT}
							<p class="ajax_loading"><img class="vertical_alignment" src="{$IMG*,loading}" /></p>

							<script>// <![CDATA[
								function load_tab__{TAB_CODE%}(automated)
								{
									if (typeof window['load_tab__{TAB_CODE%}'].done!='undefined' && window['load_tab__{TAB_CODE%}'].done) return;

									if (automated)
									{
										try { window.scrollTo(0,0); } catch (e) {};
									}

									// Self destruct loader after this first run
									window['load_tab__{TAB_CODE%}'].done=true;

									load_snippet('profile_tab&tab={TAB_CODE%}&member_id={MEMBER_ID%}'+window.location.search.replace('?','&'),null,function(result) {
										set_inner_html(document.getElementById('g_{TAB_CODE%}'),result.responseText);

										find_url_tab();
									});
								}
							//]]></script>
						{+END}
					</div>
				{+END}
			</div>
		</div>
	{+END}

	{+START,IF,{$EQ,{TABS},1}}
		{+START,LOOP,TABS}
			{+START,IF_PASSED,TAB_CONTENT}
				{TAB_CONTENT}
			{+END}
		{+END}
	{+END}
</div>

{+START,IF,{$GT,{TABS},1}}
	<script>// <![CDATA[
		// we do not want it to scroll down
		var old_hash=window.location.hash;
		window.location.hash='#';

		add_event_listener_abstract(window,'load',function() {
			window.location.hash='#';

			find_url_tab(old_hash);
		});
	//]]></script>
{+END}
