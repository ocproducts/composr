(function ($cms) {
    'use strict';
    /**
     * @param name
     * @param ajax_url
     * @param root_id
     * @param opts
     * @param multi_selection
     * @param tabindex
     * @param all_nodes_selectable
     * @param use_server_id
     * @returns {TreeList|*}
     */
    $cms.ui.createTreeList = function createTreeList(name, ajax_url, root_id, opts, multi_selection, tabindex, all_nodes_selectable, use_server_id) {
        var options = {
                name: name,
                ajax_url: ajax_url,
                root_id: root_id,
                options: opts,
                multi_selection: multi_selection,
                tabindex: tabindex,
                all_nodes_selectable: all_nodes_selectable,
                use_server_id: use_server_id
            },
            el = $cms.dom.$('#tree_list__root_' + name);

        return new $cms.views.TreeList(options, {el: el});
    };

    $cms.views.TreeList = TreeList;

    /** @class */
    function TreeList(params) {
        TreeList.base(this, 'constructor', arguments);

        this.name = params.name;
        this.ajax_url = params.ajax_url;
        this.options = params.options;
        this.multi_selection = !!params.multi_selection;
        this.tabindex = params.tabindex || null;
        this.all_nodes_selectable = !!params.all_nodes_selectable;
        this.use_server_id = !!params.use_server_id;

        $cms.dom.html(this.el, '<div class="ajax_loading vertical_alignment"><img src="' + $cms.img('{$IMG*;^,loading}') + '" alt="" /> <span>{!LOADING;^}</span></div>');

        // Initial rendering
        var url = $cms.baseUrl(this.ajax_url);
        if (params.root_id) {
            url += '&id=' + encodeURIComponent(params.root_id);
        }
        url += '&options=' + this.options;
        url += '&default=' + encodeURIComponent($cms.dom.$id(this.name).value);

        $cms.doAjaxRequest(url, this);

        var that = this;
        $cms.dom.on(document.documentElement, 'mousemove', function (event) {
            that.specialKeyPressed = !!(event.ctrlKey || event.altKey || event.metaKey || event.shiftKey)
        });
    }

    $cms.inherits(TreeList, $cms.View, /**@lends TreeList#*/ {
        specialKeyPressed: false,

        tree_list_data: '',
        busy: false,
        last_clicked: null, // The hyperlink object that was last clicked (usage during multi selection when holding down shift)

        /* Go through our tree list looking for a particular XML node */
        getElementByIdHack: function (id, type, ob, serverid) {
            var i, test, done = false;

            type || (type = 'c');
            ob || (ob = this.tree_list_data);
            serverid = !!serverid;

            // Normally we could only ever use getElementsByTagName, but Konqueror and Safari don't like it
            try {// IE9 beta has serious problems
                if (ob.getElementsByTagName) {
                    var results = ob.getElementsByTagName((type === 'c') ? 'category' : 'entry');
                    for (i = 0; i < results.length; i++) {
                        if ((results[i].getAttribute !== undefined) && (results[i].getAttribute(serverid ? 'serverid' : 'id') == id)) {
                            return results[i];
                        }
                    }
                    done = true;
                }
            } catch (e) {}

            if (!done) {
                for (i = 0; i < ob.children.length; i++) {
                    if (ob.children[i].localName === 'category') {
                        test = this.getElementByIdHack(id, type, ob.children[i], serverid);
                        if (test) {
                            return test;
                        }
                    }
                    if ((ob.children[i].localName === ((type === 'c') ? 'category' : 'entry')) && (ob.children[i].getAttribute(serverid ? 'serverid' : 'id') == id)) {
                        return ob.children[i];
                    }
                }
            }
            return null;
        },

        response: function (ajax_result_frame, ajax_result, expanding_id) {
            if (!ajax_result) {
                return;
            }

            try {
                ajax_result = document.importNode(ajax_result, true);
            } catch (e) {}

            var i, xml, temp_node, html;
            if (!expanding_id) {// Root
                html = $cms.dom.$id('tree_list__root_' + this.name);
                $cms.dom.html(html, '');

                this.tree_list_data = ajax_result.cloneNode(true);
                xml = this.tree_list_data;

                if (!xml.firstElementChild) {
                    var error = document.createTextNode((this.name.indexOf('category') == -1 && window.location.href.indexOf('category') == -1) ? '{!NO_ENTRIES;^}' : '{!NO_CATEGORIES;^}');
                    html.className = 'red_alert';
                    html.appendChild(error);
                    return;
                }
            } else { // Appending
                xml = this.getElementByIdHack(expanding_id, 'c');
                for (i = 0; i < ajax_result.childNodes.length; i++) {
                    temp_node = ajax_result.childNodes[i];
                    xml.appendChild(temp_node.cloneNode(true));
                }
                html = $cms.dom.$id(this.name + 'tree_list_c_' + expanding_id);
            }

            attributes_full_fixup(xml);

            this.root_element = this.renderTree(xml, html);

            var name = this.name;
            fixup_node_positions(name);
        },

        renderTree: function (xml, html, element) {
            var that = this, i, colour, new_html, url, escaped_title,
                initially_expanded, selectable, extra, title, func,
                temp, master_html, node, node_self_wrap, node_self;

            element || (element = $cms.dom.$id(this.name));

            $cms.dom.clearTransitionAndSetOpacity(html, 0.0);
            $cms.dom.fadeTransition(html, 100, 30, 4);

            html.style.display = xml.firstElementChild ? 'block' : 'none';

            forEach(xml.children, function (node) {
                var el, html_node, expanding;

                // Special handling of 'options' nodes, inject new options
                if (node.localName === 'options') {
                    that.options = encodeURIComponent($cms.dom.html(node));
                    return;
                }

                // Special handling of 'expand' nodes, which say to pre-expand some categories as soon as the page loads
                if (node.localName === 'expand') {
                    el = $cms.dom.$('#' + that.name + 'texp_c_' + $cms.dom.html(node));
                    if (el) {
                        html_node = $cms.dom.$('#' + that.name + 'tree_list_c_' + $cms.dom.html(node));
                        expanding = (html_node.style.display != 'block');
                        if (expanding)
                            el.onclick(null, true);
                    } else {
                        // Now try against serverid
                        var xml_node = that.getElementByIdHack($cms.dom.html(node), 'c', null, true);
                        if (xml_node) {
                            el = $cms.dom.$('#' + that.name + 'texp_c_' + xml_node.getAttribute('id'));
                            if (el) {
                                html_node = $cms.dom.$id(that.name + 'tree_list_c_' + xml_node.getAttribute('id'));
                                expanding = (html_node.style.display != 'block');
                                if (expanding) {
                                    el.onclick(null, true);
                                }
                            }
                        }
                    }
                    return;
                }

                // Category or entry nodes
                extra = ' ';
                func = node.getAttribute('img_func_1');
                if (func) {
                    extra = extra + eval(func + '(node)');
                }
                func = node.getAttribute('img_func_2');
                if (func) {
                    extra = extra + eval(func + '(node)');
                }
                node_self_wrap = document.createElement('div');
                node_self = document.createElement('div');
                node_self.style.display = 'inline-block';
                node_self_wrap.appendChild(node_self);
                node_self.object = that;
                colour = (node.getAttribute('selectable') == 'true' || that.all_nodes_selectable) ? 'native_ui_foreground' : 'locked_input_field';
                selectable = (node.getAttribute('selectable') == 'true' || that.all_nodes_selectable);
                if (node.localName === 'category') {
                    // Render self
                    node_self.className = (node.getAttribute('highlighted') == 'true') ? 'tree_list_highlighted' : 'tree_list_nonhighlighted';
                    initially_expanded = (node.getAttribute('has_children') != 'true') || (node.getAttribute('expanded') == 'true');
                    escaped_title = $cms.filter.html((node.getAttribute('title') !== undefined) ? node.getAttribute('title') : '');
                    if (escaped_title == '') escaped_title = '{!NA_EM;^}';
                    var description = '';
                    var description_in_use = '';
                    if (node.getAttribute('description_html')) {
                        description = node.getAttribute('description_html');
                        description_in_use = $cms.filter.html(description);
                    } else {
                        if (node.getAttribute('description')) description = $cms.filter.html('. ' + node.getAttribute('description'));
                        description_in_use = escaped_title + ': {!TREE_LIST_SELECT*;^}' + description + ((node.getAttribute('serverid') == '') ? (' (' + $cms.filter.html(node.getAttribute('serverid')) + ')') : '');
                    }
                    var img_url = $cms.img('{$IMG;,1x/treefield/category}');
                    var img_url_2 = $cms.img('{$IMG;,2x/treefield/category}');
                    if (node.getAttribute('img_url')) {
                        img_url = node.getAttribute('img_url');
                        img_url_2 = node.getAttribute('img_url_2');
                    }
                    $cms.dom.html(node_self, ' \
				<div> \
					<input class="ajax_tree_expand_icon"' + (that.tabindex ? (' tabindex="' + that.tabindex + '"') : '') + ' type="image" alt="' + ((!initially_expanded) ? '{!EXPAND;^}' : '{!CONTRACT;^}') + ': ' + escaped_title + '" title="' + ((!initially_expanded) ? '{!EXPAND;^}' : '{!CONTRACT;^}') + '" id="' + that.name + 'texp_c_' + node.getAttribute('id') + '" src="' + $cms.url(!initially_expanded ? '{$IMG*;,1x/treefield/expand}' : '{$IMG*;,1x/treefield/collapse}') + '" srcset="' + $cms.url(!initially_expanded ? '{$IMG*;,2x/treefield/expand}' : '{$IMG*;,2x/treefield/collapse}') + ' 2x" /> \
					<img class="ajax_tree_cat_icon" alt="{!CATEGORY;^}" src="' + $cms.filter.html(img_url) + '" srcset="' + $cms.filter.html(img_url_2) + ' 2x" /> \
					<label id="' + that.name + 'tsel_c_' + node.getAttribute('id') + '" for="' + that.name + 'tsel_r_' + node.getAttribute('id') + '" data-mouseover-activate-tooltip="[\'' + (node.getAttribute('description_html') ? '' : $cms.filter.html(description_in_use)) + '\', \'auto\']" class="ajax_tree_magic_button ' + colour + '"><input ' + (that.tabindex ? ('tabindex="' + that.tabindex + '" ') : '') + 'id="' + that.name + 'tsel_r_' + node.getAttribute('id') + '" style="position: absolute; left: -10000px" type="radio" name="_' + that.name + '" value="1" title="' + description_in_use + '" />' + escaped_title + '</label> \
					<span id="' + that.name + 'extra_' + node.getAttribute('id') + '">' + extra + '</span> \
				</div> \
			');
                    var expand_button = node_self.querySelector('input');
                    expand_button.oncontextmenu = returnFalse;
                    expand_button.object = that;
                    expand_button.onclick = function (event, automated) {
                        if ($cms.dom.$('#choose_' + that.name)) {
                            $cms.dom.$('#choose_' + that.name).click();
                        }

                        if (event) {
                            event.preventDefault();
                        }
                        that.handleTreeClick.call(expand_button, event, automated);
                        return false;

                    };
                    var a = node_self.querySelector('label');
                    expand_button.onkeypress = a.onkeypress = a.firstElementChild.onkeypress = function (expand_button) {
                        return function (event) {
                            if (((event.keyCode ? event.keyCode : event.charCode) == 13) || ['+', '-', '='].includes(String.fromCharCode(event.keyCode ? event.keyCode : event.charCode))) {
                                expand_button.onclick(event);
                            }
                        }
                    }(expand_button);
                    a.oncontextmenu = returnFalse;
                    a.handleSelection = that.handleSelection;
                    a.firstElementChild.addEventListener('focus', function () {
                        this.parentNode.style.outline = '1px dotted';
                    });
                    a.firstElementChild.addEventListener('blur', function () {
                        this.parentNode.style.outline = '';
                    });
                    a.firstElementChild.addEventListener('click', a.handleSelection);
                    a.addEventListener('click', a.handleSelection); // Needed by Firefox, the radio button's onclick will not be called if shift/ctrl held
                    a.firstElementChild.object = this;
                    a.object = this;
                    a.addEventListener('mousedown', function (event) { // To disable selection of text when holding shift or control
                        if (event.ctrlKey || event.metaKey || event.shiftKey) {
                            if (event.cancelable) {
                                event.preventDefault();
                            }
                        }
                    });
                    html.appendChild(node_self_wrap);

                    // Do any children
                    new_html = document.createElement('div');
                    new_html.role = 'treeitem';
                    new_html.id = that.name + 'tree_list_c_' + node.getAttribute('id');
                    new_html.style.display = ((!initially_expanded) || (node.getAttribute('has_children') != 'true')) ? 'none' : 'block';
                    new_html.style.padding/*{$?,{$EQ,{!en_left},left},Left,Right}*/ = '15px';
                    var selected = ((that.use_server_id ? node.getAttribute('serverid') : node.getAttribute('id')) == element.value && element.value != '') || node.getAttribute('selected') == 'yes';
                    if (selectable) {
                        that.makeElementLookSelected($cms.dom.$id(that.name + 'tsel_c_' + node.getAttribute('id')), selected);
                        if (selected) {
                            element.value = (that.use_server_id ? node.getAttribute('serverid') : node.getAttribute('id')); // Copy in proper ID for what is selected, not relying on what we currently have as accurate
                            if (element.value != '') {
                                if (element.selected_title === undefined) element.selected_title = '';
                                if (element.selected_title != '') element.selected_title += ',';
                                element.selected_title += node.getAttribute('title');
                            }
                            if (element.onchange) element.onchange();
                            if (element.fakeonchange !== undefined && element.fakeonchange) element.fakeonchange();
                        }
                    }
                    node_self.appendChild(new_html);

                    // Auto-expand
                    if (that.specialKeyPressed && !initially_expanded) {
                        expand_button.onclick();
                    }
                } else { // Assume entry
                    new_html = null;

                    escaped_title = $cms.filter.html((node.getAttribute('title') !== undefined) ? node.getAttribute('title') : '');
                    if (escaped_title == '') escaped_title = '{!NA_EM;^}';

                    var description = '';
                    var description_in_use = '';
                    if (node.getAttribute('description_html')) {
                        description = node.getAttribute('description_html');
                        description_in_use = $cms.filter.html(description);
                    } else {
                        if (node.getAttribute('description')) description = $cms.filter.html('. ' + node.getAttribute('description'));
                        description_in_use = escaped_title + ': {!TREE_LIST_SELECT*;^}' + description + ((node.getAttribute('serverid') == '') ? (' (' + $cms.filter.html(node.getAttribute('serverid')) + ')') : '');
                    }

                    // Render self
                    initially_expanded = false;
                    var img_url = $cms.img('{$IMG;,1x/treefield/entry}');
                    var img_url_2 = $cms.img('{$IMG;,2x/treefield/entry}');
                    if (node.getAttribute('img_url')) {
                        img_url = node.getAttribute('img_url');
                        img_url_2 = node.getAttribute('img_url_2');
                    }
                    $cms.dom.html(node_self, '<div><img alt="{!ENTRY;^}" src="' + $cms.filter.html(img_url) + '" srcset="' + $cms.filter.html(img_url_2) + ' 2x" style="width: 14px; height: 14px" /> ' +
                        '<label id="' + this.name + 'tsel_e_' + node.getAttribute('id') + '" class="ajax_tree_magic_button ' + colour + '" for="' + this.name + 'tsel_s_' + node.getAttribute('id') + '" data-mouseover-activate-tooltip="[\'' + (node.getAttribute('description_html') ? '' : (description_in_use.replace(/\n/g, '').replace(/'/g, '\\\''))) + '\', \'800px\']">' +
                        '<input' + (this.tabindex ? (' tabindex="' + this.tabindex + '"') : '') + ' id="' + this.name + 'tsel_s_' + node.getAttribute('id') + '" style="position: absolute; left: -10000px" type="radio" name="_' + this.name + '" value="1" />' + escaped_title + '</label>' + extra + '</div>');
                    var a = node_self.querySelector('label');
                    a.handleSelection = that.handleSelection;
                    a.firstElementChild.addEventListener('focus', function () {
                        this.parentNode.style.outline = '1px dotted';
                    });
                    a.firstElementChild.addEventListener('blur', function () {
                        this.parentNode.style.outline = '';
                    });
                    a.firstElementChild.addEventListener('click', a.handleSelection);
                    a.addEventListener('click', a.handleSelection); // Needed by Firefox, the radio button's onclick will not be called if shift/ctrl held
                    a.firstElementChild.object = that;
                    a.object = that;
                    a.addEventListener('mousedown', function (event) { // To disable selection of text when holding shift or control
                        if (event.ctrlKey || event.metaKey || event.shiftKey) {
                            if (event.cancelable) {
                                event.preventDefault();
                            }
                        }
                    });
                    html.appendChild(node_self_wrap);
                    var selected = ((that.use_server_id ? node.getAttribute('serverid') : node.getAttribute('id')) == element.value) || node.getAttribute('selected') == 'yes';
                    if ((that.multi_selection) && (!selected)) {
                        selected = ((',' + element.value + ',').indexOf(',' + node.getAttribute('id') + ',') != -1);
                    }
                    that.makeElementLookSelected($cms.dom.$id(that.name + 'tsel_e_' + node.getAttribute('id')), selected);
                }

                if ((node.getAttribute('draggable')) && (node.getAttribute('draggable') !== 'false')) {
                    master_html = $cms.dom.$id('tree_list__root_' + that.name);
                    fix_up_node_position(node_self);
                    node_self.cms_draggable = node.getAttribute('draggable');
                    node_self.draggable = true;
                    node_self.ondragstart = function (event) {
                        $cms.ui.clearOutTooltips();

                        this.className += ' being_dragged';

                        window.is_doing_a_drag = true;
                    };
                    node_self.ondrag = function (event) {
                        if (!event.clientY) return;
                        var hit = find_overlapping_selectable(event.clientY + window.pageYOffset, this, this.object.tree_list_data, this.object.name);
                        if (this.last_hit != null) {
                            this.last_hit.parentNode.parentNode.style.border = '0px';
                        }
                        if (hit != null) {
                            hit.parentNode.parentNode.style.border = '1px dotted green';
                            this.last_hit = hit;
                        }
                    };
                    node_self.ondragend = function (event) {
                        window.is_doing_a_drag = false;

                        this.classList.remove('being_dragged');

                        if (this.last_hit != null) {
                            this.last_hit.parentNode.parentNode.style.border = '0px';

                            if (this.parentNode.parentNode != this.last_hit) {
                                var xml_node = this.object.getElementByIdHack(this.querySelector('input').id.substr(7 + this.object.name.length));
                                var target_xml_node = this.object.getElementByIdHack(this.last_hit.id.substr(12 + this.object.name.length));

                                if ((this.last_hit.childNodes.length === 1) && (this.last_hit.childNodes[0].nodeName === '#text')) {
                                    $cms.dom.html(this.last_hit, '');
                                    this.object.renderTree(target_xml_node, this.last_hit);
                                }

                                // Change HTML
                                this.parentNode.parentNode.removeChild(this.parentNode);
                                this.last_hit.appendChild(this.parentNode);

                                // Change node structure
                                xml_node.parentNode.removeChild(xml_node);
                                target_xml_node.appendChild(xml_node);

                                // Ajax request
                                eval('drag_' + xml_node.getAttribute('draggable') + '("' + xml_node.getAttribute('serverid') + '","' + target_xml_node.getAttribute('serverid') + '")');

                                fixup_node_positions(this.object.name);
                            }
                        }
                    };
                }

                if ((node.getAttribute('droppable')) && (node.getAttribute('droppable') !== 'false')) {
                    node_self.ondragover = function (event) {
                        if (event.cancelable) {
                            event.preventDefault();
                        }
                    };
                    node_self.ondrop = function (event) {
                        if (event.cancelable) {
                            event.preventDefault();
                        }
                        // ondragend will call with last_hit set, we don't track the drop spots using this event handler, we track it in real time using mouse coordinate analysis
                    };
                }

                if (initially_expanded) {
                    that.renderTree(node, new_html, element);
                } else if (new_html) {
                    $cms.dom.append(new_html, '{!PLEASE_WAIT;^}');
                }
            });

            $cms.dom.triggerResize();

            return a;
        },

        handleTreeClick: function (event, automated) {// Not called as a method
            var element = $cms.dom.$id(this.object.name),
                xml_node;
            if (element.disabled || this.object.busy) {
                return false;
            }

            this.object.busy = true;

            var clicked_id = this.getAttribute('id').substr(7 + this.object.name.length);

            var html_node = $cms.dom.$id(this.object.name + 'tree_list_c_' + clicked_id);
            var expand_button = $cms.dom.$id(this.object.name + 'texp_c_' + clicked_id);

            var expanding = (html_node.style.display != 'block');

            if (expanding) {
                xml_node = this.object.getElementByIdHack(clicked_id, 'c');
                xml_node.setAttribute('expanded', 'true');
                var real_clicked_id = xml_node.getAttribute('serverid');
                if (typeof real_clicked_id !== 'string') {
                    real_clicked_id = clicked_id;
                }

                if ((xml_node.getAttribute('has_children') === 'true') && !xml_node.firstElementChild) {
                    var url = $cms.baseUrl(this.object.ajax_url + '&id=' + encodeURIComponent(real_clicked_id) + '&options=' + this.object.options + '&default=' + encodeURIComponent(element.value));
                    var ob = this.object;
                    $cms.doAjaxRequest(url, function (ajax_result_frame, ajax_result) {
                        $cms.dom.html(html_node, '');
                        ob.response(ajax_result_frame, ajax_result, clicked_id);
                    });
                    $cms.dom.html(html_node, '<div aria-busy="true" class="vertical_alignment"><img src="' + $cms.img('{$IMG*;,loading}') + '" alt="" /> <span>{!LOADING;^}</span></div>');
                    var container = $cms.dom.$id('tree_list__root_' + ob.name);
                    if ((automated) && (container) && (container.style.overflowY == 'auto')) {
                        window.setTimeout(function () {
                            container.scrollTop = $cms.dom.findPosY(html_node) - 20;
                        }, 0);
                    }
                }

                html_node.style.display = 'block';
                $cms.dom.clearTransitionAndSetOpacity(html_node, 0.0);
                $cms.dom.fadeTransition(html_node, 100, 30, 4);

                expand_button.src = $cms.img('{$IMG;,1x/treefield/collapse}');
                expand_button.srcset = $cms.img('{$IMG;,2x/treefield/collapse}') + ' 2x';
                expand_button.title = expand_button.title.replace('{!EXPAND;^}', '{!CONTRACT;^}');
                expand_button.alt = expand_button.alt.replace('{!EXPAND;^}', '{!CONTRACT;^}');
            } else {
                xml_node = this.object.getElementByIdHack(clicked_id, 'c');
                xml_node.setAttribute('expanded', 'false');
                html_node.style.display = 'none';

                expand_button.src = $cms.img('{$IMG;,1x/treefield/expand}');
                expand_button.srcset = $cms.img('{$IMG;,2x/treefield/expand}') + ' 2x';
                expand_button.title = expand_button.title.replace('{!CONTRACT;^}', '{!EXPAND;^}');
                expand_button.alt = expand_button.alt.replace('{!CONTRACT;^}', '{!EXPAND;^}');
            }

            fixup_node_positions(this.object.name);

            $cms.dom.triggerResize();

            this.object.busy = false;

            return true;
        },

        handleSelection: function (event, assume_ctrl) {// Not called as a method
            assume_ctrl = !!assume_ctrl;

            var element = $cms.dom.$id(this.object.name);
            if (element.disabled) {
                return;
            }
            var i,
                selected_before = (element.value == '') ? [] : (this.object.multi_selection ? element.value.split(',') : [element.value]);

            event.stopPropagation();
            event.preventDefault();

            if (!assume_ctrl && event.shiftKey && this.object.multi_selection) {
                // We're holding down shift so we need to force selection of everything bounded between our last click spot and here
                var all_a = $cms.dom.$id('tree_list__root_' + this.object.name).getElementsByTagName('label');
                var pos_last = -1;
                var pos_us = -1;
                if (this.object.last_clicked == null) this.object.last_clicked = all_a[0];
                for (i = 0; i < all_a.length; i++) {
                    if (all_a[i] == this || all_a[i] == this.parentNode) pos_us = i;
                    if (all_a[i] == this.object.last_clicked || all_a[i] == this.object.last_clicked.parentNode) pos_last = i;
                }
                if (pos_us < pos_last) // ReOrder them
                {
                    var temp = pos_us;
                    pos_us = pos_last;
                    pos_last = temp;
                }
                var that_selected_id, that_xml_node, that_type;
                for (i = 0; i < all_a.length; i++) {
                    that_type = this.getAttribute('id').charAt(5 + this.object.name.length);
                    if (that_type == 'r') {
                        that_type = 'c';
                    }
                    if (that_type == 's') {
                        that_type = 'e';
                    }

                    if (all_a[i].getAttribute('id').substr(5 + this.object.name.length, that_type.length) == that_type) {
                        that_selected_id = (this.object.use_server_id) ? all_a[i].getAttribute('serverid') : all_a[i].getAttribute('id').substr(7 + this.object.name.length);
                        that_xml_node = this.object.getElementByIdHack(that_selected_id, that_type);
                        if ((that_xml_node.getAttribute('selectable') == 'true') || (this.object.all_nodes_selectable)) {
                            if ((i >= pos_last) && (i <= pos_us)) {
                                if (selected_before.indexOf(that_selected_id) == -1)
                                    all_a[i].handleSelection(event, true);
                            } else {
                                if (selected_before.indexOf(that_selected_id) != -1)
                                    all_a[i].handleSelection(event, true);
                            }
                        }
                    }
                }

                return;
            }
            var type = this.getAttribute('id').charAt(5 + this.object.name.length);
            if (type === 'r') {
                type = 'c';
            } else if (type === 's') {
                type = 'e';
            }
            var real_selected_id = this.getAttribute('id').substr(7 + this.object.name.length),
                xml_node = this.object.getElementByIdHack(real_selected_id, type),
                selected_id = (this.object.use_server_id) ? xml_node.getAttribute('serverid') : real_selected_id;

            if (xml_node.getAttribute('selectable') == 'true' || this.object.all_nodes_selectable) {
                var selected_after = selected_before;
                for (i = 0; i < selected_before.length; i++) {
                    this.object.makeElementLookSelected($cms.dom.$id(this.object.name + 'tsel_' + type + '_' + selected_before[i]), false);
                }
                if ((!this.object.multi_selection) || (((!event.ctrlKey) && (!event.metaKey) && (!event.altKey)) && (!assume_ctrl))) {
                    selected_after = [];
                }
                if ((selected_before.indexOf(selected_id) != -1) && (((selected_before.length == 1) && (selected_before[0] != selected_id)) || ((event.ctrlKey) || (event.metaKey) || (event.altKey)) || (assume_ctrl))) {
                    for (var key in selected_after) {
                        if (selected_after[key] == selected_id)
                            selected_after.splice(key, 1);
                    }
                } else if (selected_after.indexOf(selected_id) == -1) {
                    selected_after.push(selected_id);
                    if (!this.object.multi_selection) {// This is a bit of a hack to make selection look nice, even though we aren't storing natural IDs of what is selected
                        var anchors = $cms.dom.$id('tree_list__root_' + this.object.name).getElementsByTagName('label');
                        for (i = 0; i < anchors.length; i++) {
                            this.object.makeElementLookSelected(anchors[i], false);
                        }
                        this.object.makeElementLookSelected($cms.dom.$id(this.object.name + 'tsel_' + type + '_' + real_selected_id), true);
                    }
                }
                for (i = 0; i < selected_after.length; i++) {
                    this.object.makeElementLookSelected($cms.dom.$id(this.object.name + 'tsel_' + type + '_' + selected_after[i]), true);
                }

                element.value = selected_after.join(',');
                element.selected_title = (selected_after.length == 1) ? xml_node.getAttribute('title') : element.value;
                element.selected_editlink = xml_node.getAttribute('edit');
                if (element.value == '') {
                    element.selected_title = '';
                }
                if (element.onchange) {
                    element.onchange();
                }
                if (element.fakeonchange !== undefined && element.fakeonchange) {
                    element.fakeonchange();
                }
            }

            if (!assume_ctrl) {
                this.object.last_clicked = this;
            }
        },

        makeElementLookSelected: function (target, selected) {
            if (!target) {
                return;
            }
            target.classList.toggle('native_ui_selected', !!selected);
            target.style.cursor = 'pointer';
        }
    });

    function attributes_full_fixup(xml) {
        var node, i,
            id = xml.getAttribute('id');

        window.attributes_full || (window.attributes_full = {});
        window.attributes_full[id] || (window.attributes_full[id] = {});

        for (i = 0; i < xml.attributes.length; i++) {
            window.attributes_full[id][xml.attributes[i].name] = xml.attributes[i].value;
        }
        for (i = 0; i < xml.children.length; i++) {
            node = xml.children[i];

            if ((node.localName === 'category') || (node.localName === 'entry')) {
                attributes_full_fixup(node);
            }
        }
    }

    function fixup_node_positions(name) {
        var html = $cms.dom.$('#tree_list__root_' + name);
        var to_fix = html.getElementsByTagName('div');
        var i;
        for (i = 0; i < to_fix.length; i++) {
            if (to_fix[i].style.position === 'absolute') {
                fix_up_node_position(to_fix[i]);
            }
        }
    }

    function fix_up_node_position(node_self) {
        node_self.style.left = $cms.dom.findPosX(node_self.parentNode, true) + 'px';
        node_self.style.top = $cms.dom.findPosY(node_self.parentNode, true) + 'px';
    }

    function find_overlapping_selectable(mouse_y, element, node, name) { // Find drop targets
        var i, childNode, temp, child_node_element, y, height;

        // Recursion
        if (node.getAttribute('expanded') !== 'false') {
            for (i = 0; i < node.children.length; i++) {
                childNode = node.children[i];
                temp = find_overlapping_selectable(mouse_y, element, childNode, name);
                if (temp) {
                    return temp;
                }
            }
        }

        if (node.getAttribute('droppable') == element.cms_draggable) {
            child_node_element = $cms.dom.$id(name + 'tree_list_' + ((node.localName === 'category') ? 'c' : 'e') + '_' + node.getAttribute('id'));
            y = $cms.dom.findPosY(child_node_element.parentNode.parentNode, true);
            height = child_node_element.parentNode.parentNode.offsetHeight;
            if ((y < mouse_y) && (y + height > mouse_y)) {
                return child_node_element;
            }
        }

        return null;
    }
}(window.$cms));