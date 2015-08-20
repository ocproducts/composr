(function() {
	CKEDITOR.plugins.add('composr', {
        hidpi: true,

		icons: 'composr_block,composr_comcode,composr_page,composr_quote,composr_box,composr_code,composr_image',

		init: function(editor) {
			var possibles=['block','comcode','page','quote','box','code'];
			for (var i=0;i<possibles.length;i++)
			{
				var buttonName=possibles[i];
				var elements=get_elements_by_class_name(editor.element.$.parentNode.parentNode,'comcode_button_'+buttonName);
				if (typeof elements[0]!='undefined')
				{
					var func={
						exec: function(e) { return function() { e.onclick.call(e); } }(elements[0])
					};
					var label=elements[0].alt;

					editor.addCommand('composr_'+buttonName,func);
					editor.ui.addButton && editor.ui.addButton('composr_'+buttonName,{
						label: label,
						command: 'composr_'+buttonName
					});

					elements[0].parentNode.parentNode.style.display='none';
				}
			}

			var func={
				exec: function(e) {
					var has_selection=(e.getSelection().getSelectedElement()!=null);

					if (typeof window.start_simplified_upload!='undefined' && !has_selection)
					{
						var test=start_simplified_upload(editor.element.$.id);
						if (test) return;
					}

					if (typeof window.lang_PREFER_CMS_ATTACHMENTS=='undefined' || has_selection) {
						editor.execCommand('image');
					} else
					{
						fauxmodal_alert(window.lang_PREFER_CMS_ATTACHMENTS,function() {
							editor.execCommand('image');
						});
					}
				}
			};
			editor.addCommand('composr_image',func);
			editor.ui.addButton && editor.ui.addButton('composr_image',{
				label: editor.lang.common.image,
				command: 'composr_image'
			});
		}
	});
})();
