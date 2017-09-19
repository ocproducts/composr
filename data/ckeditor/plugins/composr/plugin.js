(function () {
	CKEDITOR.plugins.add('composr', {
		hidpi: true,

		icons: 'composr_block,composr_comcode,composr_page,composr_quote,composr_box,composr_code,composr_image',

        /**
         * @param { CKEDITOR.editor } editor
         */
		init: function (editor) {
			var possibles = ['block', 'comcode', 'page', 'quote', 'box', 'code'];

            possibles.forEach(function (buttonName) {
                var element = editor.element.$.parentNode.parentNode.querySelector('.js-comcode-button-' + buttonName);

                if (element != null) {
                    editor.addCommand('composr_' + buttonName, {
                        exec: function () {
                            $cms.dom.trigger(element, 'click');
                        }
                    });
                    
                    if (editor.ui.addButton) {
                        editor.ui.addButton('composr_' + buttonName, {
                            label: element.alt,
                            command: 'composr_' + buttonName
                        });
                    }

                    //element.parentNode.parentNode.style.display = 'none';
                }
            });

			var usesPlupload = false,
                aub = document.getElementById('js-attachment-upload-button'),
                doingAttachmentUploads = Boolean(aub) && (aub.classList.contains('for_field_' + editor.element.$.id));

			if ((window.rebuildAttachmentButtonForNext !== undefined) && doingAttachmentUploads) {
				if (!aub || (aub.parentNode.parentNode.style.display === 'none')) { // If attachment button was not placed elsewhere
					setTimeout(function () {
                        window.rebuildAttachmentButtonForNext(editor.element.$.id, document.getElementById('cke_' + editor.element.$.id).querySelector('.cke_button__composr_image').id);
					}, 0);

					usesPlupload = true;
				}
			}
            
			editor.addCommand('composr_image', {
                exec: function (e) {
                    if (doingAttachmentUploads) {
                        var hasSelection = (e.getSelection().getSelectedElement() != null);
                        if (usesPlupload && !hasSelection) { // Not selected an image for editing, so don't show an edit dialogue
                            return;
                        }
                    }

                    if ((window.lang_PREFER_CMS_ATTACHMENTS === undefined) || hasSelection || !doingAttachmentUploads) {
                        editor.execCommand('image');
                    } else {
                        $cms.ui.alert(window.lang_PREFER_CMS_ATTACHMENTS).then(function () {
                            editor.execCommand('image');
                        });
                    }
                }
            });
			
			if (editor.ui.addButton) {
                editor.ui.addButton('composr_image', {
                    label: editor.lang.common.image,
                    command: 'composr_image'
                });
            }
		}
	});
})();
