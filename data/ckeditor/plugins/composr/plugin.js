(function () {
	CKEDITOR.plugins.add('composr', {
		hidpi: true,

		icons: 'composr_block,composr_comcode,composr_page,composr_quote,composr_box,composr_code,composr_image',

        /**
         * @param { CKEDITOR.editor } editor
         */
		init: function (editor) {
			var possibles = ['block', 'comcode', 'page', 'quote', 'box', 'code'], 
				func;
            
			possibles.forEach(function (buttonName) {
				var element = editor.element.$.parentNode.parentNode.querySelector('.js-comcode-button-' + buttonName);

				if (element != null) {
					func = {
						exec: function () {
							$cms.dom.trigger(element, 'click');
						}
					};
					editor.addCommand('composr_' + buttonName, func);
					if (editor.ui.addButton) {
						editor.ui.addButton('composr_' + buttonName, {
							label: element.alt,
							command: 'composr_' + buttonName
						});
					}
                    
                    $cms.dom.hide($cms.dom.parent(element, '#post_special_options, #post_special_options2'));
				}
			});

			var usesPlupload = false,
				aub = document.getElementById('js-attachment-upload-button'),
				doingAttachmentUploads = Boolean(aub) && (aub.classList.contains('for_field_' + editor.element.$.id));
            
			if (doingAttachmentUploads) {
				if (!aub || $cms.dom.notDisplayed($cms.dom.parent(aub, '#post_special_options, #post_special_options2'))) { // If attachment button was not placed elsewhere
                    // Attach Plupload to the Image button on the WYSIWYG editor
					setTimeout(function () {
					    var imageButton = document.getElementById('cke_' + editor.element.$.id).querySelector('.cke_button__composr_image');
						window.rebuildAttachmentButtonForNext(editor.element.$.id, imageButton.id);
					}, 0);

					usesPlupload = true;
				}
			}

			func = {
				exec: function (e) {
					var hasSelection = false;
					if (doingAttachmentUploads) {
                        hasSelection = (e.getSelection().getSelectedElement() != null);
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
			};
			editor.addCommand('composr_image', func);
			if (editor.ui.addButton) {
			    // Add the Image button to the WYSIWYG editor
				editor.ui.addButton('composr_image', {
					label: editor.lang.common.image,
					command: 'composr_image'
				});
			}
		}
	});
})();
