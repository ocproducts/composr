{$REQUIRE_JAVASCRIPT,ajax}

{+START,IF,{$NOT,{$TAPATALK}}}
	<span class="comcode_member_link" onblur="this.onmouseover(event);" onfocus="this.onmouseleave(event);" onmouseover="var _this=this; this.cancelled=false; load_snippet('member_tooltip&amp;member_id={MEMBER_ID%}',null,function(result) { if (typeof window.activate_tooltip!='undefined' &amp;&amp; !this.cancelled) activate_tooltip(_this,event,result.responseText,'auto',null,null,false,true); });" onmouseleave="deactivate_tooltip(this); this.cancelled=true;">
		<img class="embedded_mini_avatar" src="{$?*,{$IS_EMPTY,{$AVATAR,{MEMBER_ID}}},{$IMG,cns_default_avatars/default},{$ENSURE_PROTOCOL_SUITABILITY*,{$AVATAR,{MEMBER_ID}}}}" alt="" />
		<a href="{MEMBER_URL*}">{USERNAME*}</a>
	</span>
{+END}
{+START,IF,{$TAPATALK}}
	<a href="{MEMBER_URL*}">{USERNAME*}</a>
{+END}
