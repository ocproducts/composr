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
						<a aria-controls="g_{TAB_CODE*}" role="tab" href="#!" onclick="event.returnValue=false; select_tab('g','{TAB_CODE;*}'); return false;">{+START,IF_NON_EMPTY,{TAB_ICON}}<img alt="" src="{$IMG*,icons/24x24/{TAB_ICON}}" srcset="{$IMG*,icons/48x48/{TAB_ICON}} 2x" /> {+END}<span>{TAB_TITLE*}</span></a>
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

<script type="application/json" data-tpl-core-cns="cnsMemberProfileScreen">
	{+START,PARAMS_JSON,TABS,TAB_CODE,TAB_CONTENT,MEMBER_ID}{_/}{+END}
</script>