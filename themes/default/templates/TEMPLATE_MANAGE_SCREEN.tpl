{TITLE}

<p>{!TEMPLATE_CHOOSE_TO_EDIT}</p>

{+START,LOOP,EDIT_FORMS}
	<h2>{_TITLE*}</h2>

	{FORM}
{+END}

<script>// <![CDATA[
	window.current_theme='{THEME;/}';
	load_template_previews();
//]]></script>
