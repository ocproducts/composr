{+START,IF,{$JS_ON}}
	<input id="mass_select_button" disabled="disabled" onclick="mass_delete_click(this);" class="button_screen menu___generic_admin__delete" type="button" value="{!DELETE_SELECTION}" />

	<script>// <![CDATA[
		function initialise_button_visibility()
		{
			var id=document.getElementById('id');
			var ids=(id.value=='')?[]:id.value.split(/,/);

			document.getElementById('submit_button').disabled=(ids.length!=1);
			document.getElementById('mass_select_button').disabled=(ids.length==0);
		};

		function mass_delete_click(ob)
		{
			var callback=function() {
				var id=document.getElementById('id');
				var ids=(id.value=='')?[]:id.value.split(/,/);

				for (var i=0;i<ids.length;i++)
				{
					prepare_mass_select_marker('','{TYPE;/}',ids[i],true);
				}

				ob.form.method='post';
				ob.form.action='{$PAGE_LINK;/,_SELF:_SELF:mass_delete}';
				ob.form.target='_top';
				ob.form.submit();
			};
			confirm_delete(ob.form,true,callback);
		}

		add_event_listener_abstract(window,'load',function() {
			document.getElementById('id').fakeonchange=initialise_button_visibility;
			initialise_button_visibility();
		});
	//]]></script>
{+END}
