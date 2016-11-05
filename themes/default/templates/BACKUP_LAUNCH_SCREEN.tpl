{TITLE}

<h2>{!PREVIOUS}</h2>

{RESULTS}

<p>{TEXT*}</p>

<h2>{!NEW}</h2>

{FORM}

<script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		var submit_button=document.getElementById('submit_button');
		submit_button.old_onclick=submit_button.onclick;
		submit_button.onclick=function(event) {
			submit_button.old_onclick(event);
			submit_button.disabled=true;
		};

		var button=document.createElement('input');
		button.type='button';
		button.className='button_micro buttons__proceed';
		button.value='{!CALCULATE_SIZE;}';
		var max_size_field=document.getElementById('max_size');
		button.onclick=function() {
			var progress_ticker=document.createElement('img');
			progress_ticker.setAttribute('src','{$IMG;,loading}');
			progress_ticker.style.verticalAlign='middle';
			progress_ticker.style.marginLeft='20px';
			button.parentNode.appendChild(progress_ticker,button);
			window.fauxmodal_alert('{!CALCULATED_SIZE;}'.replace('\{1\}',load_snippet('backup_size&max_size='+window.encodeURIComponent(max_size_field.value))));
			button.parentNode.removeChild(progress_ticker);
		};
		max_size_field.parentNode.appendChild(button,max_size_field);
	});
//]]></script>
