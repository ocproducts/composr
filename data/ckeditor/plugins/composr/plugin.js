(function () {
	CKEDITOR.plugins.add('composr', {
		hidpi: true,

		icons: 'composr_block,composr_comcode,composr_page,composr_quote,composr_box,composr_code,composr_image',

		init: function (editor) {
			var possibles = ['block', 'comcode', 'page', 'quote', 'box', 'code'], func;
			
			for (var i = 0; i < possibles.length; i++) {
				var buttonName = possibles[i],
                    element = editor.element.$.parentNode.parentNode.querySelector('.comcode_button_' + buttonName),
                    label;
				
				if (element != null) {
					func = {
                        exec: (function (element) {
                            $cms.dom.trigger(element, 'click');
                        }).bind(undefined, element)
					};
                    label = element.alt;

					editor.addCommand('composr_' + buttonName, func);
					
					if (editor.ui.addButton) {
                        editor.ui.addButton('composr_' + buttonName, {
                            label: label,
                            command: 'composr_' + buttonName
                        });
                    }

					element.parentNode.parentNode.style.display = 'none';
				}
			}

			var usesPlupload = false;

			var aub = document.getElementById('attachment_upload_button');
			var doingAttachmentUploads = (aub) && (aub.classList.contains('for_field_' + editor.element.$.id));

			if ((typeof window.rebuildAttachmentButtonForNext !== 'undefined') && (doingAttachmentUploads)) {
				if (!aub || (aub.parentNode.parentNode.style.display === 'none')) { // If attachment button was not placed elsewhere
					window.setTimeout(function () {
						rebuildAttachmentButtonForNext(editor.element.$.id, document.getElementById('cke_' + editor.element.$.id).getElementsByClassName('cke_button__composr_image')[0].id);
					}, 0);

					usesPlupload = true;
				}
			}

			func = {
				exec: function (e) {
					if (doingAttachmentUploads) {
						var hasSelection = (e.getSelection().getSelectedElement() != null);
						if (usesPlupload && !hasSelection) { // Not selected an image for editing, so don't show an edit dialogue
						    return;
                        } 
					}

					if ((typeof window.lang_PREFER_CMS_ATTACHMENTS === 'undefined') || hasSelection || !doingAttachmentUploads) {
						editor.execCommand('image');
					} else {
						$cms.ui.alert(window.lang_PREFER_CMS_ATTACHMENTS).then(function () {
							editor.execCommand('image');
						});
					}
				}
			};
			editor.addCommand('composr_image', func);
			editor.ui.addButton && editor.ui.addButton('composr_image', {
				label: editor.lang.common.image,
				command: 'composr_image'
			});
		}
	});
})();
