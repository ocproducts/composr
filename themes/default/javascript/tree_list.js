(function ($cms) {
    'use strict';
    /**
     * @param name
     * @param ajaxUrl
     * @param rootId
     * @param opts
     * @param multiSelection
     * @param tabindex
     * @param allNodesSelectable
     * @param useServerId
     * @returns { $cms.views.TreeList }
     */
    $cms.ui.createTreeList = function createTreeList(name, ajaxUrl, rootId, opts, multiSelection, tabindex, allNodesSelectable, useServerId) {
        var options = {
                name: name,
                ajax_url: ajaxUrl,
                root_id: rootId,
                options: opts,
                multi_selection: multiSelection,
                tabindex: tabindex,
                all_nodes_selectable: allNodesSelectable,
                use_server_id: useServerId
            },
            el = $cms.dom.$id('tree_list__root_' + name);

        return new $cms.views.TreeList(options, {el: el});
    };

    $cms.views.TreeList = TreeList;
    /**
     * @memberof $cms.views
     * @class TreeList
     * @extends $cms.View
     */
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

        $cms.doAjaxRequest(url, this.response.bind(this));

        $cms.dom.on(document.documentElement, 'mousemove', (function (event) {
            this.specialKeyPressed = !!(event.ctrlKey || event.altKey || event.metaKey || event.shiftKey)
        }).bind(this));
    }

    $cms.inherits(TreeList, $cms.View, /**@lends TreeList#*/ {
        specialKeyPressed: false,
        tree_list_data: '',
        busy: false,
        last_clicked: null, // The hyperlink object that was last clicked (usage during multi selection when holding down shift)

        /* Go through our tree list looking for a particular XML node */
        getElementByIdHack: function getElementByIdHack(id, type, ob, serverid) {
            var i, test, done = false;

            type = strVal(type) || 'c';
            ob = ob || this.tree_list_data;
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

        response: function response(ajaxResultFrame, ajaxResult, expandingId) {
            if (!ajaxResult) {
                return;
            }

            try {
                ajaxResult = document.importNode(ajaxResult, true);
            } catch (e) {}

            var i, xml, tempNode, html;
            if (!expandingId) {// Root
                html = $cms.dom.$id('tree_list__root_' + this.name);
                $cms.dom.html(html, '');

                this.tree_list_data = ajaxResult.cloneNode(true);
                xml = this.tree_list_data;

                if (!xml.firstElementChild) {
                    var error = document.createTextNode((this.name.indexOf('category') == -1 && window.location.href.indexOf('category') == -1) ? '{!NO_ENTRIES;^}' : '{!NO_CATEGORIES;^}');
                    html.className = 'red_alert';
                    html.appendChild(error);
                    return;
                }
            } else { // Appending
                xml = this.getElementByIdHack(expandingId, 'c');
                for (i = 0; i < ajaxResult.childNodes.length; i++) {
                    tempNode = ajaxResult.childNodes[i];
                    xml.appendChild(tempNode.cloneNode(true));
                }
                html = $cms.dom.$id(this.name + 'tree_list_c_' + expandingId);
            }

            attributesFullFixup(xml);

            this.root_element = this.renderTree(xml, html);

            var name = this.name;
            fixupNodePositions(name);
        },

        renderTree: function renderTree(xml, html, element) {
            var that = this, i, colour, newHtml, url, escapedTitle,
                initiallyExpanded, selectable, extra, title, func,
                temp, masterHtml, node, nodeSelfWrap, nodeSelf, a;

            element || (element = $cms.dom.$id(this.name));

            $cms.dom.clearTransitionAndSetOpacity(html, 0.0);
            $cms.dom.fadeTransition(html, 100, 30, 4);

            html.style.display = xml.firstElementChild ? 'block' : 'none';

            $cms.forEach(xml.children, function (node) {
                var el, htmlNode, expanding;

                // Special handling of 'options' nodes, inject new options
                if (node.localName === 'options') {
                    that.options = encodeURIComponent($cms.dom.html(node));
                    return;
                }

                // Special handling of 'expand' nodes, which say to pre-expand some categories as soon as the page loads
                if (node.localName === 'expand') {
                    el = $cms.dom.$id(that.name + 'texp_c_' + $cms.dom.html(node));
                    if (el) {
                        htmlNode = $cms.dom.$id(that.name + 'tree_list_c_' + $cms.dom.html(node));
                        expanding = (htmlNode.style.display !== 'block');
                        if (expanding)
                            el.onclick(null, true);
                    } else {
                        // Now try against serverid
                        var xmlNode = that.getElementByIdHack($cms.dom.html(node), 'c', null, true);
                        if (xmlNode) {
                            el = $cms.dom.$id(that.name + 'texp_c_' + xmlNode.getAttribute('id'));
                            if (el) {
                                htmlNode = $cms.dom.$id(that.name + 'tree_list_c_' + xmlNode.getAttribute('id'));
                                expanding = (htmlNode.style.display !== 'block');
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
                nodeSelfWrap = document.createElement('div');
                nodeSelf = document.createElement('div');
                nodeSelf.style.display = 'inline-block';
                nodeSelfWrap.appendChild(nodeSelf);
                nodeSelf.object = that;
                colour = (node.getAttribute('selectable') == 'true' || that.all_nodes_selectable) ? 'native_ui_foreground' : 'locked_input_field';
                selectable = (node.getAttribute('selectable') == 'true' || that.all_nodes_selectable);
                if (node.localName === 'category') {
                    // Render self
                    nodeSelf.className = (node.getAttribute('highlighted') == 'true') ? 'tree_list_highlighted' : 'tree_list_nonhighlighted';
                    initiallyExpanded = (node.getAttribute('has_children') != 'true') || (node.getAttribute('expanded') == 'true');
                    escapedTitle = $cms.filter.html((node.getAttribute('title') !== undefined) ? node.getAttribute('title') : '');
                    if (escapedTitle == '') escapedTitle = '{!NA_EM;^}';
                    var description = '';
                    var descriptionInUse = '';
                    if (node.getAttribute('description_html')) {
                        description = node.getAttribute('description_html');
                        descriptionInUse = $cms.filter.html(description);
                    } else {
                        if (node.getAttribute('description')) description = $cms.filter.html('. ' + node.getAttribute('description'));
                        descriptionInUse = escapedTitle + ': {!TREE_LIST_SELECT*;^}' + description + ((node.getAttribute('serverid') == '') ? (' (' + $cms.filter.html(node.getAttribute('serverid')) + ')') : '');
                    }
                    var imgUrl = $cms.img('{$IMG;,1x/treefield/category}');
                    var imgUrl2 = $cms.img('{$IMG;,2x/treefield/category}');
                    if (node.getAttribute('img_url')) {
                        imgUrl = node.getAttribute('img_url');
                        imgUrl2 = node.getAttribute('img_url_2');
                    }
                    $cms.dom.html(nodeSelf, ' \
				<div> \
					<input class="ajax_tree_expand_icon"' + (that.tabindex ? (' tabindex="' + that.tabindex + '"') : '') + ' type="image" alt="' + ((!initiallyExpanded) ? '{!EXPAND;^}' : '{!CONTRACT;^}') + ': ' + escapedTitle + '" title="' + ((!initiallyExpanded) ? '{!EXPAND;^}' : '{!CONTRACT;^}') + '" id="' + that.name + 'texp_c_' + node.getAttribute('id') + '" src="' + $cms.url(!initiallyExpanded ? '{$IMG*;,1x/treefield/expand}' : '{$IMG*;,1x/treefield/collapse}') + '" srcset="' + $cms.url(!initiallyExpanded ? '{$IMG*;,2x/treefield/expand}' : '{$IMG*;,2x/treefield/collapse}') + ' 2x" /> \
					<img class="ajax_tree_cat_icon" alt="{!CATEGORY;^}" src="' + $cms.filter.html(imgUrl) + '" srcset="' + $cms.filter.html(imgUrl2) + ' 2x" /> \
					<label id="' + that.name + 'tsel_c_' + node.getAttribute('id') + '" for="' + that.name + 'tsel_r_' + node.getAttribute('id') + '" data-mouseover-activate-tooltip="[\'' + (node.getAttribute('description_html') ? '' : $cms.filter.html(descriptionInUse)) + '\', \'auto\']" class="ajax_tree_magic_button ' + colour + '"><input ' + (that.tabindex ? ('tabindex="' + that.tabindex + '" ') : '') + 'id="' + that.name + 'tsel_r_' + node.getAttribute('id') + '" style="position: absolute; left: -10000px" type="radio" name="_' + that.name + '" value="1" title="' + descriptionInUse + '" />' + escapedTitle + '</label> \
					<span id="' + that.name + 'extra_' + node.getAttribute('id') + '">' + extra + '</span> \
				</div> \
			');
                    var expandButton = nodeSelf.querySelector('input');
                    expandButton.oncontextmenu = $cms.returnFalse;
                    expandButton.object = that;
                    expandButton.onclick = function (event, automated) {
                        if ($cms.dom.$id('choose_' + that.name)) {
                            $cms.dom.$id('choose_' + that.name).click();
                        }

                        if (event) {
                            event.preventDefault();
                        }
                        that.handleTreeClick.call(expandButton, event, automated);
                        return false;

                    };
                    a = nodeSelf.querySelector('label');
                    expandButton.onkeypress = a.onkeypress = a.firstElementChild.onkeypress = function (expandButton) {
                        return function (event) {
                            if (((event.keyCode ? event.keyCode : event.charCode) == 13) || ['+', '-', '='].includes(String.fromCharCode(event.keyCode ? event.keyCode : event.charCode))) {
                                expandButton.onclick(event);
                            }
                        }
                    }(expandButton);
                    a.oncontextmenu = $cms.returnFalse;
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
                    html.appendChild(nodeSelfWrap);

                    // Do any children
                    newHtml = document.createElement('div');
                    newHtml.role = 'treeitem';
                    newHtml.id = that.name + 'tree_list_c_' + node.getAttribute('id');
                    newHtml.style.display = ((!initiallyExpanded) || (node.getAttribute('has_children') != 'true')) ? 'none' : 'block';
                    newHtml.style.padding/*{$?,{$EQ,{!en_left},left},Left,Right}*/ = '15px';
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
                    nodeSelf.appendChild(newHtml);

                    // Auto-expand
                    if (that.specialKeyPressed && !initiallyExpanded) {
                        expandButton.onclick();
                    }
                } else { // Assume entry
                    newHtml = null;

                    escapedTitle = $cms.filter.html((node.getAttribute('title') !== undefined) ? node.getAttribute('title') : '');
                    if (escapedTitle === '') escapedTitle = '{!NA_EM;^}';

                    var description = '';
                    var descriptionInUse = '';
                    if (node.getAttribute('description_html')) {
                        description = node.getAttribute('description_html');
                        descriptionInUse = $cms.filter.html(description);
                    } else {
                        if (node.getAttribute('description')) description = $cms.filter.html('. ' + node.getAttribute('description'));
                        descriptionInUse = escapedTitle + ': {!TREE_LIST_SELECT*;^}' + description + ((node.getAttribute('serverid') == '') ? (' (' + $cms.filter.html(node.getAttribute('serverid')) + ')') : '');
                    }

                    // Render self
                    initiallyExpanded = false;
                    var imgUrl = $cms.img('{$IMG;,1x/treefield/entry}');
                    var imgUrl2 = $cms.img('{$IMG;,2x/treefield/entry}');
                    if (node.getAttribute('img_url')) {
                        imgUrl = node.getAttribute('img_url');
                        imgUrl2 = node.getAttribute('img_url_2');
                    }
                    $cms.dom.html(nodeSelf, '<div><img alt="{!ENTRY;^}" src="' + $cms.filter.html(imgUrl) + '" srcset="' + $cms.filter.html(imgUrl2) + ' 2x" style="width: 14px; height: 14px" /> ' +
                        '<label id="' + this.name + 'tsel_e_' + node.getAttribute('id') + '" class="ajax_tree_magic_button ' + colour + '" for="' + this.name + 'tsel_s_' + node.getAttribute('id') + '" data-mouseover-activate-tooltip="[\'' + (node.getAttribute('description_html') ? '' : (descriptionInUse.replace(/\n/g, '').replace(/'/g, '\\\''))) + '\', \'800px\']">' +
                        '<input' + (this.tabindex ? (' tabindex="' + this.tabindex + '"') : '') + ' id="' + this.name + 'tsel_s_' + node.getAttribute('id') + '" style="position: absolute; left: -10000px" type="radio" name="_' + this.name + '" value="1" />' + escapedTitle + '</label>' + extra + '</div>');
                    var a = nodeSelf.querySelector('label');
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
                    html.appendChild(nodeSelfWrap);
                    var selected = ((that.use_server_id ? node.getAttribute('serverid') : node.getAttribute('id')) == element.value) || node.getAttribute('selected') == 'yes';
                    if ((that.multi_selection) && (!selected)) {
                        selected = ((',' + element.value + ',').indexOf(',' + node.getAttribute('id') + ',') != -1);
                    }
                    that.makeElementLookSelected($cms.dom.$id(that.name + 'tsel_e_' + node.getAttribute('id')), selected);
                }

                if ((node.getAttribute('draggable')) && (node.getAttribute('draggable') !== 'false')) {
                    masterHtml = $cms.dom.$id('tree_list__root_' + that.name);
                    fixUpNodePosition(nodeSelf);
                    nodeSelf.cms_draggable = node.getAttribute('draggable');
                    nodeSelf.draggable = true;
                    nodeSelf.ondragstart = function (event) {
                        $cms.ui.clearOutTooltips();

                        this.className += ' being_dragged';

                        window.is_doing_a_drag = true;
                    };
                    nodeSelf.ondrag = function (event) {
                        if (!event.clientY) return;
                        var hit = findOverlappingSelectable(event.clientY + window.pageYOffset, this, this.object.tree_list_data, this.object.name);
                        if (this.last_hit != null) {
                            this.last_hit.parentNode.parentNode.style.border = '0px';
                        }
                        if (hit != null) {
                            hit.parentNode.parentNode.style.border = '1px dotted green';
                            this.last_hit = hit;
                        }
                    };
                    nodeSelf.ondragend = function (event) {
                        window.is_doing_a_drag = false;

                        this.classList.remove('being_dragged');

                        if (this.last_hit != null) {
                            this.last_hit.parentNode.parentNode.style.border = '0px';

                            if (this.parentNode.parentNode != this.last_hit) {
                                var xmlNode = this.object.getElementByIdHack(this.querySelector('input').id.substr(7 + this.object.name.length));
                                var targetXmlNode = this.object.getElementByIdHack(this.last_hit.id.substr(12 + this.object.name.length));

                                if ((this.last_hit.childNodes.length === 1) && (this.last_hit.childNodes[0].nodeName === '#text')) {
                                    $cms.dom.html(this.last_hit, '');
                                    this.object.renderTree(targetXmlNode, this.last_hit);
                                }

                                // Change HTML
                                this.parentNode.parentNode.removeChild(this.parentNode);
                                this.last_hit.appendChild(this.parentNode);

                                // Change node structure
                                xmlNode.parentNode.removeChild(xmlNode);
                                targetXmlNode.appendChild(xmlNode);

                                // Ajax request
                                eval('drag_' + xmlNode.getAttribute('draggable') + '("' + xmlNode.getAttribute('serverid') + '","' + targetXmlNode.getAttribute('serverid') + '")');

                                fixupNodePositions(this.object.name);
                            }
                        }
                    };
                }

                if ((node.getAttribute('droppable')) && (node.getAttribute('droppable') !== 'false')) {
                    nodeSelf.ondragover = function (event) {
                        if (event.cancelable) {
                            event.preventDefault();
                        }
                    };
                    nodeSelf.ondrop = function (event) {
                        if (event.cancelable) {
                            event.preventDefault();
                        }
                        // ondragend will call with last_hit set, we don't track the drop spots using this event handler, we track it in real time using mouse coordinate analysis
                    };
                }

                if (initiallyExpanded) {
                    that.renderTree(node, newHtml, element);
                } else if (newHtml) {
                    $cms.dom.append(newHtml, '{!PLEASE_WAIT;^}');
                }
            });

            $cms.dom.triggerResize();

            return a;
        },

        handleTreeClick: function handleTreeClick(event, automated) {// Not called as a method
            var element = $cms.dom.$id(this.object.name),
                xmlNode;
            if (element.disabled || this.object.busy) {
                return false;
            }

            this.object.busy = true;

            var clickedId = this.getAttribute('id').substr(7 + this.object.name.length);

            var htmlNode = $cms.dom.$id(this.object.name + 'tree_list_c_' + clickedId);
            var expandButton = $cms.dom.$id(this.object.name + 'texp_c_' + clickedId);

            var expanding = (htmlNode.style.display !== 'block');

            if (expanding) {
                xmlNode = this.object.getElementByIdHack(clickedId, 'c');
                xmlNode.setAttribute('expanded', 'true');
                var realClickedId = xmlNode.getAttribute('serverid');
                if (typeof realClickedId !== 'string') {
                    realClickedId = clickedId;
                }

                if ((xmlNode.getAttribute('has_children') === 'true') && !xmlNode.firstElementChild) {
                    var url = $cms.baseUrl(this.object.ajax_url + '&id=' + encodeURIComponent(realClickedId) + '&options=' + this.object.options + '&default=' + encodeURIComponent(element.value));
                    var ob = this.object;
                    $cms.doAjaxRequest(url, function (ajaxResultFrame, ajaxResult) {
                        $cms.dom.html(htmlNode, '');
                        ob.response(ajaxResultFrame, ajaxResult, clickedId);
                    });
                    $cms.dom.html(htmlNode, '<div aria-busy="true" class="vertical_alignment"><img src="' + $cms.img('{$IMG*;,loading}') + '" alt="" /> <span>{!LOADING;^}</span></div>');
                    var container = $cms.dom.$id('tree_list__root_' + ob.name);
                    if ((automated) && (container) && (container.style.overflowY == 'auto')) {
                        window.setTimeout(function () {
                            container.scrollTop = $cms.dom.findPosY(htmlNode) - 20;
                        }, 0);
                    }
                }

                htmlNode.style.display = 'block';
                $cms.dom.clearTransitionAndSetOpacity(htmlNode, 0.0);
                $cms.dom.fadeTransition(htmlNode, 100, 30, 4);

                expandButton.src = $cms.img('{$IMG;,1x/treefield/collapse}');
                expandButton.srcset = $cms.img('{$IMG;,2x/treefield/collapse}') + ' 2x';
                expandButton.title = expandButton.title.replace('{!EXPAND;^}', '{!CONTRACT;^}');
                expandButton.alt = expandButton.alt.replace('{!EXPAND;^}', '{!CONTRACT;^}');
            } else {
                xmlNode = this.object.getElementByIdHack(clickedId, 'c');
                xmlNode.setAttribute('expanded', 'false');
                htmlNode.style.display = 'none';

                expandButton.src = $cms.img('{$IMG;,1x/treefield/expand}');
                expandButton.srcset = $cms.img('{$IMG;,2x/treefield/expand}') + ' 2x';
                expandButton.title = expandButton.title.replace('{!CONTRACT;^}', '{!EXPAND;^}');
                expandButton.alt = expandButton.alt.replace('{!CONTRACT;^}', '{!EXPAND;^}');
            }

            fixupNodePositions(this.object.name);

            $cms.dom.triggerResize();

            this.object.busy = false;

            return true;
        },

        handleSelection: function handleSelection(event, assumeCtrl) {// Not called as a method
            assumeCtrl = !!assumeCtrl;

            var element = $cms.dom.$id(this.object.name);
            if (element.disabled) {
                return;
            }
            var i,
                selectedBefore = (element.value == '') ? [] : (this.object.multi_selection ? element.value.split(',') : [element.value]);

            event.stopPropagation();
            event.preventDefault();

            if (!assumeCtrl && event.shiftKey && this.object.multi_selection) {
                // We're holding down shift so we need to force selection of everything bounded between our last click spot and here
                var allA = $cms.dom.$id('tree_list__root_' + this.object.name).getElementsByTagName('label');
                var posLast = -1;
                var posUs = -1;
                if (this.object.last_clicked == null) this.object.last_clicked = allA[0];
                for (i = 0; i < allA.length; i++) {
                    if (allA[i] == this || allA[i] == this.parentNode) posUs = i;
                    if (allA[i] == this.object.last_clicked || allA[i] == this.object.last_clicked.parentNode) posLast = i;
                }
                if (posUs < posLast) // ReOrder them
                {
                    var temp = posUs;
                    posUs = posLast;
                    posLast = temp;
                }
                var thatSelectedId, thatXmlNode, thatType;
                for (i = 0; i < allA.length; i++) {
                    thatType = this.getAttribute('id').charAt(5 + this.object.name.length);
                    if (thatType == 'r') {
                        thatType = 'c';
                    }
                    if (thatType == 's') {
                        thatType = 'e';
                    }

                    if (allA[i].getAttribute('id').substr(5 + this.object.name.length, thatType.length) == thatType) {
                        thatSelectedId = (this.object.use_server_id) ? allA[i].getAttribute('serverid') : allA[i].getAttribute('id').substr(7 + this.object.name.length);
                        thatXmlNode = this.object.getElementByIdHack(thatSelectedId, thatType);
                        if ((thatXmlNode.getAttribute('selectable') == 'true') || (this.object.all_nodes_selectable)) {
                            if ((i >= posLast) && (i <= posUs)) {
                                if (selectedBefore.indexOf(thatSelectedId) == -1)
                                    allA[i].handleSelection(event, true);
                            } else {
                                if (selectedBefore.indexOf(thatSelectedId) != -1)
                                    allA[i].handleSelection(event, true);
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
            var realSelectedId = this.getAttribute('id').substr(7 + this.object.name.length),
                xmlNode = this.object.getElementByIdHack(realSelectedId, type),
                selectedId = (this.object.use_server_id) ? xmlNode.getAttribute('serverid') : realSelectedId;

            if (xmlNode.getAttribute('selectable') == 'true' || this.object.all_nodes_selectable) {
                var selectedAfter = selectedBefore;
                for (i = 0; i < selectedBefore.length; i++) {
                    this.object.makeElementLookSelected($cms.dom.$id(this.object.name + 'tsel_' + type + '_' + selectedBefore[i]), false);
                }
                if ((!this.object.multi_selection) || (((!event.ctrlKey) && (!event.metaKey) && (!event.altKey)) && (!assumeCtrl))) {
                    selectedAfter = [];
                }
                if ((selectedBefore.indexOf(selectedId) != -1) && (((selectedBefore.length == 1) && (selectedBefore[0] != selectedId)) || ((event.ctrlKey) || (event.metaKey) || (event.altKey)) || (assumeCtrl))) {
                    for (var key in selectedAfter) {
                        if (selectedAfter[key] == selectedId)
                            selectedAfter.splice(key, 1);
                    }
                } else if (selectedAfter.indexOf(selectedId) == -1) {
                    selectedAfter.push(selectedId);
                    if (!this.object.multi_selection) {// This is a bit of a hack to make selection look nice, even though we aren't storing natural IDs of what is selected
                        var anchors = $cms.dom.$id('tree_list__root_' + this.object.name).getElementsByTagName('label');
                        for (i = 0; i < anchors.length; i++) {
                            this.object.makeElementLookSelected(anchors[i], false);
                        }
                        this.object.makeElementLookSelected($cms.dom.$id(this.object.name + 'tsel_' + type + '_' + realSelectedId), true);
                    }
                }
                for (i = 0; i < selectedAfter.length; i++) {
                    this.object.makeElementLookSelected($cms.dom.$id(this.object.name + 'tsel_' + type + '_' + selectedAfter[i]), true);
                }

                element.value = selectedAfter.join(',');
                element.selected_title = (selectedAfter.length == 1) ? xmlNode.getAttribute('title') : element.value;
                element.selected_editlink = xmlNode.getAttribute('edit');
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

            if (!assumeCtrl) {
                this.object.last_clicked = this;
            }
        },

        makeElementLookSelected: function makeElementLookSelected(target, selected) {
            if (!target) {
                return;
            }
            target.classList.toggle('native_ui_selected', !!selected);
            target.style.cursor = 'pointer';
        }
    });

    function attributesFullFixup(xml) {
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
                attributesFullFixup(node);
            }
        }
    }

    function fixupNodePositions(name) {
        var html = $cms.dom.$id('tree_list__root_' + name);
        var toFix = html.getElementsByTagName('div');
        var i;
        for (i = 0; i < toFix.length; i++) {
            if (toFix[i].style.position === 'absolute') {
                fixUpNodePosition(toFix[i]);
            }
        }
    }

    function fixUpNodePosition(nodeSelf) {
        nodeSelf.style.left = $cms.dom.findPosX(nodeSelf.parentNode, true) + 'px';
        nodeSelf.style.top = $cms.dom.findPosY(nodeSelf.parentNode, true) + 'px';
    }

    function findOverlappingSelectable(mouseY, element, node, name) { // Find drop targets
        var i, childNode, temp, childNodeElement, y, height;

        // Recursion
        if (node.getAttribute('expanded') !== 'false') {
            for (i = 0; i < node.children.length; i++) {
                childNode = node.children[i];
                temp = findOverlappingSelectable(mouseY, element, childNode, name);
                if (temp) {
                    return temp;
                }
            }
        }

        if (node.getAttribute('droppable') == element.cms_draggable) {
            childNodeElement = $cms.dom.$id(name + 'tree_list_' + ((node.localName === 'category') ? 'c' : 'e') + '_' + node.getAttribute('id'));
            y = $cms.dom.findPosY(childNodeElement.parentNode.parentNode, true);
            height = childNodeElement.parentNode.parentNode.offsetHeight;
            if ((y < mouseY) && (y + height > mouseY)) {
                return childNodeElement;
            }
        }

        return null;
    }
}(window.$cms));