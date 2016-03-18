{TITLE}

<p role="alert">
	{MESSAGE*}
</p>

{+START,IF,{$_GET,keep_fatalistic}}
	<div class="box box___fatal_screen"><div class="box_inner">
		{!MAYBE_NOT_FATAL}
	</div></div>
{+END}

{+START,IF_PASSED,WEBSERVICE_RESULT}
	<h2>Expanded advice</h2>

	{WEBSERVICE_RESULT}
{+END}

{+START,IF,{MAY_SEE_TRACE}}
	<h2>{!STACK_TRACE}</h2>

	{TRACE}
{+END}
{+START,IF,{$NOT,{MAY_SEE_TRACE}}}
	<p>
		{!STACK_TRACE_DENIED_ERROR_NOTIFICATION}
	</p>
{+END}

<script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		if ((typeof window.trigger_resize!='undefined') && (window.top!=window)) trigger_resize();
	});
//]]></script>
