<div class="global_button_ref_point" id="top_language_rel" style="display: none">
	<div class="box box_arrow box__block_top_language"><span></span><div class="box_inner"><div>
		<div id="language_flags">
			{+START,LOOP,LANGS}
				<div>
					<a href="{$SELF_URL*,0,1,0,keep_lang={_loop_key&}}" hreflang="{$LCASE*,{_loop_key}}">{+START,IF_NON_EMPTY,{COUNTRY_FLAG}}<img width="24" height="20" src="{$IMG*,flags_large/{$LCASE,{COUNTRY_FLAG}}}" alt="" /></a>{+END}
					<a{+START,IF,{$EQ,{CURRENT_LANG},{_loop_key}}} class="current" title="{!CURRENT} {!LANGUAGE}: {CURRENT_LANG_FULL_NAME*}"{+END} href="{$SELF_URL*,0,1,0,keep_lang={_loop_key&}}" hreflang="{$LCASE*,{_loop_key}}">{FULL_NAME*}</a>
				</div>
			{+END}
		</div>
	</div></div></div>
</div>
<a id="top_language_button" onclick="return toggle_top_language(event);" href="#">{+START,IF_NON_EMPTY,{CURRENT_LANG_COUNTRY_FLAG}}<img width="24" height="20" src="{$IMG*,flags_large/{$LCASE,{CURRENT_LANG_COUNTRY_FLAG}}}" alt="" />{+END}{+START,IF_EMPTY,{CURRENT_LANG_COUNTRY_FLAG}}{CURRENT_LANG*}{+END}</a>
