<li>
	{+START,IF_NON_EMPTY,{URL}}<a title="{TEMPLATE*} {!LINK_NEW_WINDOW}" onclick="window.open(this.href,'template_preview_{TEMPLATE%}','width=800,height=600,status=no,resizable=yes,scrollbars=yes'); return false;" href="{URL*}&amp;keep_wide_high=1" target="_blank">{+END}<span{+START,IF_NON_EMPTY,{COLOR}} style="color: {COLOR*}"{+END}>{TEMPLATE*}</span>{+START,IF_NON_EMPTY,{URL}}</a>{+END}

	{+START,IF_NON_EMPTY,{URL}}<a class="associated_link horiz_field_sep" title="{TEMPLATE*} {!LINK_NEW_WINDOW}" onclick="window.open(this.href,'template_preview_{TEMPLATE%}','width=320,height=480,status=no,resizable=yes,scrollbars=yes'); return false;" href="{URL*}&amp;keep_wide_high=1&amp;keep_mobile=1" target="_blank"><span{+START,IF_NON_EMPTY,{COLOR}} style="color: {COLOR*}"{+END}>{!MOBILE_VERSION}</span></a>{+END}

	{+START,IF_NON_EMPTY,{LIST}}
		<div class="mini_indent">
			<ul class="meta_details_list">{LIST*}</ul>
		</div>
	{+END}
</li>
