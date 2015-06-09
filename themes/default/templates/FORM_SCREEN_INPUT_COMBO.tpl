<div class="webstandards_checker_off inline">
	<input autocomplete="off" onkeyup="var l=document.getElementById('{NAME%}_fallback_list'); if (l) l.disabled=(this.value!='');" class="input_line{REQUIRED*}" tabindex="{TABINDEX*}" type="text" value="{DEFAULT*}" id="{NAME*}" name="{NAME*}" list="{NAME*}_list" />
	<datalist id="{NAME*}_list">
		<span class="associated_details">{!fields:OR_ONE_OF_THE_BELOW}:</span>
		<select size="5" name="{NAME*}" id="{NAME*}_fallback_list" class="input_list{REQUIRED*}" style="display: block; width: 14em">{$,select is for non-datalist-aware browsers}
			{CONTENT}
		</select>
	</datalist>
	<script>// <![CDATA[
		document.getElementById('{NAME%}').onkeyup();
		if (typeof window.HTMLDataListElement=='undefined') document.getElementById('{NAME%}').className='input_line';
	//]]></script>
</div>
