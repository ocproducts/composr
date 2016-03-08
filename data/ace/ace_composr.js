function ace_composr_loader(textarea_id,programming_language)
{
	// Create Ace editor div from textarea
	var textarea=document.getElementById(textarea_id);
	var val=textarea.value;
	var div=document.createElement('div');
	var ace_id=textarea_id+'__ace';
	div.id=ace_id;
	div.style.height=(textarea.rows*30)+'px';
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

	// Keep textarea in sync with the Ace editor
	editor_session.setValue(val);
	editor_session.on('change', function(){
		textarea.value=editor_session.getValue();
	});
}
