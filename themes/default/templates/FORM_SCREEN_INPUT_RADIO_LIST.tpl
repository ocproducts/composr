{$SET,early_description,1}

{+START,IF_PASSED,NAME}
	<div id="error_{NAME*}" style="display: none" class="input_error_here"></div>
{+END}

<div class="radio_list">
	{CONTENT}
</div>

{+START,IF_PASSED,NAME}
	{+START,IF,{REQUIRED}}
		<input type="hidden" name="require__{NAME*}" value="1" />
	{+END}

	{+START,IF_PASSED,CODE}
		<script>// <![CDATA[
			add_event_listener_abstract(window,'load',function() {
				choose_picture('j_{NAME|;}_{CODE|;}',null,'{NAME;/}',null);
			});
		//]]></script>
	{+END}

	{$,If is for deletion}
	{+START,IF,{$EQ,{NAME},delete}}
		<script>// <![CDATA[
			add_event_listener_abstract(window,'load',function() {
				assign_radio_deletion_confirm('{NAME;/}');
			});
		//]]></script>
	{+END}
{+END}
