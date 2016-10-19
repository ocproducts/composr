<div data-tpl="pageLinkChooser" data-tpl-params="{+START,PARAMS_JSON,NAME,PAGE_TYPE}{_*}{+END}">
{+START,IF_NON_PASSED_OR_FALSE,AS_FIELD}
<form title="{!PRIMARY_PAGE_FORM}" action="{$BASE_URL*}/index.php" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}
{+END}
	<div>
		<div class="accessibility_hidden"><label for="{NAME*}">{!ENTRY}</label></div>
		<input onchange="{+START,IF_NON_PASSED_OR_FALSE,AS_FIELD}window.returnValue=this.value; if (typeof window.faux_close!='undefined') window.faux_close(); else window.close();{+END}{+START,IF_PASSED_AND_TRUE,GET_TITLE_TOO}if (typeof this.selected_title=='undefined') { this.value=''; /*was autocomplete, unwanted*/ return; } this.value+=' '+this.selected_title;{+END}" style="display: none" type="text" id="{NAME*}" name="{NAME*}" value="{VALUE*}" />
		<div id="tree_list__root_{NAME*}">
			<!-- List put in here -->
		</div>
		<p class="associated_details">
			{!CLICK_ENTRY_POINT_TO_USE_2}
		</p>
	</div>
{+START,IF_NON_PASSED_OR_FALSE,AS_FIELD}
</form>
{+END}
</div>