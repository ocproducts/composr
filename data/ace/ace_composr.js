window.ace_editors={};

function ace_composr_loader(textarea_id,programming_language,auto_refresh)
{
	if (typeof auto_refresh=='undefined') auto_refresh=true;

	// Create Ace editor div from textarea
	var textarea=document.getElementById(textarea_id);
	var val=textarea.value;
	var div=document.createElement('div');
	var ace_id=textarea_id+'__ace';
	div.id=ace_id;
	div.style.height=(textarea.rows*20)+'px';
	textarea.style.display='none';
	textarea.parentNode.insertBefore(div,textarea);

	// Initialise Ace editor
	var editor=ace.edit(ace_id);
	editor.setTheme('ace/theme/textmate');
	var editor_session=editor.getSession();
	editor_session.setMode('ace/mode/'+programming_language);
	editor_session.setUseWrapMode(false);
	editor.setHighlightActiveLine(true);
	editor.setShowPrintMargin(false);
	editor.$blockScrolling=Infinity;
	if (val.indexOf('{+')!=-1 || val.indexOf('{$')!=-1)
	{
		// Troublesome Tempcode, so no syntax validation
		editor_session.setOption('useWorker',false);
	}

	// Save reference
	window.ace_editors[textarea_id]=editor;

	// Keep textarea in sync with the Ace editor
	editor_session.setValue(val);
	if (auto_refresh)
	{
		editor_session.on('change',function() {
			editarea_reverse_refresh(textarea_id);
		});
	}
}

function editarea_is_loaded(textarea_id)
{
	return (typeof window.ace_editors[textarea_id]!='undefined');
}

function editarea_do_search(textarea_id,regexp)
{
	var editor=window.ace_editors[textarea_id];

	editor.find(regexp,{
		wrap: true,
		caseSensitive: false,
		regExp: true
	});

	try
	{
		window.scrollTo(0,find_pos_y(document.getElementById(textarea_id).parentNode,true));
	}
	catch (e) {}
}

function editarea_reverse_refresh(textarea_id)
{
	var editor=window.ace_editors[textarea_id];
	if (typeof editor=='undefined') return;

	document.getElementById(textarea_id).value=editor.getValue();
}

function editarea_refresh(textarea_id)
{
	var editor=window.ace_editors[textarea_id];
	if (typeof editor=='undefined') return;

	editor.setValue(document.getElementById(textarea_id).value,-1);
}

function editarea_set_value(textarea_id,value)
{
	var editor=window.ace_editors[textarea_id];

	editor.setValue(value,-1);
}

function editarea_get_value(textarea_id)
{
	var editor=window.ace_editors[textarea_id];

	return editor.getValue();
}
