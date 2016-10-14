"use strict";

/*
Poll for notifications (and unread PTs)
*/

if (typeof window.notifications_time_barrier=='undefined')
{
	window.notifications_already_presented={};

	window.NOTIFICATION_POLL_FREQUENCY={$CONFIG_OPTION%,notification_poll_frequency};

	window.notifications_time_barrier=null;
}

function notification_poller_init(time_barrier)
{
	require_javascript('sound',window.SoundManager);

	window.notifications_time_barrier=time_barrier;

	window.setInterval(window.poll_for_notifications,window.NOTIFICATION_POLL_FREQUENCY*1000);

	var web_notifications_button=document.getElementById('web_notifications_button');
	if (web_notifications_button)
		add_event_listener_abstract(web_notifications_button,'click',explicit_notifications_enable_request);
}

function notifications_mark_all_read(event)
{
	var url='{$FIND_SCRIPT;,notifications}?type=poller&type=mark_all_read';
	if (typeof window.max_notifications_to_show!='undefined') url+='&max='+window.max_notifications_to_show;
	url+='&time_barrier='+window.encodeURIComponent(window.notifications_time_barrier);
	url+='&forced_update=1';
	url+=keep_stub();
	do_ajax_request(url,window._poll_for_notifications);
	_toggle_messaging_box(event,'web_notifications',true);
	return false;
}

function poll_for_notifications(forced_update,delay)
{
	if (typeof forced_update=='undefined') forced_update=false;
	if (typeof delay=='undefined') delay=false;

	if (delay)
	{
		window.setTimeout(function() {
			poll_for_notifications(forced_update);
		},1000);
		return;
	}

	var url='{$FIND_SCRIPT;,notifications}?type=poller&type=poller';
	if (typeof window.max_notifications_to_show!='undefined') url+='&max='+window.max_notifications_to_show;
	url+='&time_barrier='+window.encodeURIComponent(window.notifications_time_barrier);
	if (forced_update) url+='&forced_update=1';
	url+=keep_stub();
	do_ajax_request(url,window._poll_for_notifications);
}

function _poll_for_notifications(raw_ajax_result)
{
	if (typeof raw_ajax_result.getElementsByTagName=='undefined')
		return; // Some kind of error

	var time_node=raw_ajax_result.getElementsByTagName('time')[0];
	window.notifications_time_barrier=window.parseInt(get_inner_html(time_node));

	// HTML5 notification API

	var alerts;

	alerts=raw_ajax_result.getElementsByTagName('web_notification');
	for (var i=0;i<alerts.length;i++)
	{
		display_alert(alerts[i]);
	}

	alerts=raw_ajax_result.getElementsByTagName('pt');
	for (var i=0;i<alerts.length;i++)
	{
		display_alert(alerts[i]);
	}

	// Show in the software directly, if possible

	var spot,display,button,unread;

	spot=document.getElementById('web_notifications_spot');
	if (spot)
	{
		display=raw_ajax_result.getElementsByTagName('display_web_notifications');
		button=document.getElementById('web_notifications_button');
		if ((typeof display[0]!='undefined') && (display[0]))
		{
			unread=raw_ajax_result.getElementsByTagName('unread_web_notifications');
			set_inner_html(spot,get_inner_html(display[0]));
			set_inner_html(button.childNodes[0],get_inner_html(unread[0]));
			button.className='count_'+get_inner_html(unread[0]);
		}
	}

	spot=document.getElementById('pts_spot');
	if (spot)
	{
		display=raw_ajax_result.getElementsByTagName('display_pts');
		button=document.getElementById('pts_button');
		if ((typeof display[0]!='undefined') && (display[0]))
		{
			unread=raw_ajax_result.getElementsByTagName('unread_pts');
			set_inner_html(spot,get_inner_html(display[0]));
			set_inner_html(button.childNodes[0],get_inner_html(unread[0]));
			button.className='count_'+get_inner_html(unread[0]);
		}
	}
}

function display_alert(notification)
{
	var id=notification.getAttribute('id');

	if (typeof window.notifications_already_presented[id]!='undefined') return; // Already handled this one

	// Play sound, if requested
	var sound=notification.getAttribute('sound');
	if (!sound) sound=(window.parseInt(notification.getAttribute('priority'))<3)?'on':'off';
	if (read_cookie('sound','off')==='off') sound='off';
	var notification_code=notification.getAttribute('notification_code');
	if (sound=='on' && typeof window.detect_change=='undefined' || notification_code!='ticket_reply' && notification_code!='ticket_reply_staff')
	{
		if (typeof window.soundManager!='undefined')
		{
			var go_func=function() {
				var sound_url='data/sounds/message_received.mp3';
				var base_url=((sound_url.indexOf('data_custom')==-1)&&(sound_url.indexOf('uploads/')==-1))?'{$BASE_URL_NOHTTP;}':'{$CUSTOM_BASE_URL_NOHTTP;}';
				var sound_object=window.soundManager.createSound({url: base_url+'/'+sound_url});
				if (sound_object) sound_object.play();
			};

			if (!window.soundManager.setupOptions.url)
			{
				window.soundManager.setup({onready: go_func, url: get_base_url()+'/data/soundmanager', debugMode: false});
			} else
			{
				go_func();
			}
		}
	}

	// Show desktop notification
	/*{+START,IF,{$CONFIG_OPTION,notification_desktop_alerts}}*/
	if (window.notify.isSupported)
	{
		var icon='{$IMG;,favicon}'.replace(/^https?:/,window.location.protocol);
		var title='{!notifications:DESKTOP_NOTIFICATION_SUBJECT;^}';
		title=title.replace(/\\{1\\}/,notification.getAttribute('subject'));
		title=title.replace(/\\{2\\}/,notification.getAttribute('from_username'));
		var body='';//notification.getAttribute('rendered'); Looks ugly
		if (window.notify.permissionLevel()==window.notify.PERMISSION_GRANTED)
		{
			var notification_wrapper=window.notify.createNotification(title,{'icon': icon,'body': body,'tag': '{$SITE_NAME;}__'+id});
			if (notification_wrapper)
			{
				add_event_listener_abstract(window,'focus',function() { notification_wrapper.close(); });

				notification_wrapper.notification.onclick=function() {
					try
					{
						window.focus();
					}
					catch (ex) {}
				};
			}
		} else
		{
			window.notify.requestPermission(); // Probably won't actually work (silent fail), as we're not running via a user-initiated event; this is why we have explicit_notifications_enable_request called elsewhere
		}
	}
	/*{+END}*/

	// Mark done
	window.notifications_already_presented[id]=true;
}

// We attach to an onclick handler, to enable desktop notifications later on; we need this as we cannot call requestPermission out of the blue
function explicit_notifications_enable_request()
{
	/*{+START,IF,{$CONFIG_OPTION,notification_desktop_alerts}}*/
	window.notify.requestPermission();
	/*{+END}*/
}

function toggle_top_personal_stats(event)
{
	if (typeof event=='undefined') event=window.event;
	_toggle_messaging_box(event,'pts',true);
	_toggle_messaging_box(event,'web_notifications',true);
	return _toggle_messaging_box(event,'top_personal_stats');
}

function toggle_web_notifications(event)
{
	if (typeof event=='undefined') event=window.event;
	_toggle_messaging_box(event,'top_personal_stats',true);
	_toggle_messaging_box(event,'pts',true);
	return _toggle_messaging_box(event,'web_notifications');
}

function toggle_pts(event)
{
	if (typeof event=='undefined') event=window.event;
	_toggle_messaging_box(event,'top_personal_stats',true);
	_toggle_messaging_box(event,'web_notifications',true);
	return _toggle_messaging_box(event,'pts');
}

function _toggle_messaging_box(event,name,hide)
{
	if (typeof hide=='undefined') hide=false;

	var e=document.getElementById(name+'_rel');
	if (!e) return;

	event.within_message_box=true;
	cancel_bubbling(event);

	var body=document.body;
	if (e.parentNode!=body) // Move over, so it is not cut off by overflow:hidden of the header
	{
		e.parentNode.removeChild(e);
		body.appendChild(e);

		add_event_listener_abstract(e,'click',function(event) { if (typeof event=='undefined') event=window.event; event.within_message_box=true; });
		add_event_listener_abstract(body,'click',function(event) { if (typeof event=='undefined') event=window.event; if (typeof event.within_message_box!='undefined') return; _toggle_messaging_box(event,'top_personal_stats',true); _toggle_messaging_box(event,'web_notifications',true); _toggle_messaging_box(event,'pts',true); });
	}

	var button=document.getElementById(name+'_button');
	button.title='';
	var set_position=function() {
		var button_x=find_pos_x(button,true);
		var button_width=find_width(button);
		var x=(button_x+button_width-find_width(e));
		if (x<0)
		{
			var span=e.getElementsByTagName('span')[0];
			span.style.marginLeft=(button_x+button_width/4)+'px';
			x=0;
		}
		e.style.left=x+'px';
		e.style.top=(find_pos_y(button,true)+find_height(button))+'px';
		try
		{
			e.style.opacity='1.0';
		}
		catch (ex) {}
	};
	window.setTimeout(set_position,0);

	if ((e.style.display=='none') && (!hide))
	{
		var tooltips=document.querySelectorAll('body>.tooltip');
		if (typeof tooltips[0]!='undefined')
			tooltips[0].style.display='none'; // Hide tooltip, to stop it being a mess

		e.style.display='inline';
	} else
	{
		e.style.display='none';
	}
	try
	{
		e.style.opacity='0.0'; // Render, but invisibly, until we've positioned it
	}
	catch (ex) {}

	return false;
}

/*{+START,IF,{$CONFIG_OPTION,notification_desktop_alerts}}*/

/**
 * Copyright 2012 Tsvetan Tsvetkov
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *	 http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Author: Tsvetan Tsvetkov (tsekach@gmail.com)
 */
(function (win) {
	/*
	 Safari native methods required for Notifications do NOT run in strict mode.
	 */
	//"use strict";
	var PERMISSION_DEFAULT = "default",
		PERMISSION_GRANTED = "granted",
		PERMISSION_DENIED = "denied",
		PERMISSION = [PERMISSION_GRANTED, PERMISSION_DEFAULT, PERMISSION_DENIED],
		defaultSetting = {
			pageVisibility: false,
			autoClose: 5000
		},
		empty = {},
		emptyString = "",
		isSupported = (function () {
			var isSupported = false;
			/*
			 * Use try {} catch() {} because the check for IE may throws an exception
			 * if the code is run on browser that is not Safar/Chrome/IE or
			 * Firefox with html5notifications plugin.
			 *
			 * Also, we canNOT detect if msIsSiteMode method exists, as it is
			 * a method of host object. In IE check for existing method of host
			 * object returns undefined. So, we try to run it - if it runs 
			 * successfully - then it is IE9+, if not - an exceptions is thrown.
			 */
			try {
				isSupported = !!(/* Safari, Chrome */win.Notification || /* Chrome & ff-html5notifications plugin */win.webkitNotifications || /* Firefox Mobile */navigator.mozNotification || /* IE9+ */(win.external && win.external.msIsSiteMode() !== undefined));
			} catch (e) {}
			return isSupported;
		}()),
		ieVerification = Math.floor((Math.random() * 10) + 1),
		isFunction = function (value) { return (value && (value).constructor === Function); },
		isString = function (value) {return (value && (value).constructor === String); },
		isObject = function (value) {return (value && (value).constructor === Object); },
		/**
		 * Dojo Mixin
		 */
		mixin = function (target, source) {
			var name, s;
			for (name in source) {
				s = source[name];
				if ((typeof target[name]=='undefined') || (!target.name) || (target[name] !== s && ((typeof empty[name]=='undefined') || (!empty[name]) || empty[name] !== s))) {
					target[name] = s;
				}
			}
			return target; // Object
		},
		noop = function () {},
		settings = defaultSetting;
	function getNotification(title, options) {
		var notification;
		if (win.Notification) { /* Safari 6, Chrome (23+) */
			notification =  new win.Notification(title, {
				/* The notification's icon - For Chrome in Windows, Linux & Chrome OS */
				icon: isString(options.icon) ? options.icon : options.icon.x32,
				/* The notification's subtitle. */
				body: options.body || emptyString,
				/*
					The notification's unique identifier.
					This prevents duplicate entries from appearing if the user has multiple instances of your website open at once.
				*/
				tag: options.tag || emptyString
			});
		} else if (win.webkitNotifications) { /* FF with html5Notifications plugin installed */
			notification = win.webkitNotifications.createNotification(options.icon, title, options.body);
			notification.tag = options.tag || emptyString;
			notification.show();
		} else if (navigator.mozNotification) { /* Firefox Mobile */
			notification = navigator.mozNotification.createNotification(title, options.body, options.icon);
			notification.tag = options.tag || emptyString;
			notification.show();
		} else if (win.external && win.external.msIsSiteMode()) { /* IE9+ */
			//Clear any previous notifications
			win.external.msSiteModeClearIconOverlay();
			win.external.msSiteModeSetIconOverlay('{$IMG;,notifications/notifications}', title);
			win.external.msSiteModeActivate();
			notification = {
				"ieVerification": ++ieVerification
			};
		} else
		{
			if (typeof win.focus!='undefined') {
				try {
					win.focus();
				}
				catch (e) {}
			}
		}
		return notification;
	}
	function getWrapper(notification) {
		return {
			notification: notification,
			close: function () {
				if (notification) {
					if (notification.close) {
						//http://code.google.com/p/ff-html5notifications/issues/detail?id=58
						notification.close();
					} else if (win.external && win.external.msIsSiteMode()) {
						if (notification.ieVerification === ieVerification) {
							win.external.msSiteModeClearIconOverlay();
						}
					}
				}
			}
		};
	}
	function requestPermission(callback) {
		if (!isSupported) { return; }
		var callbackFunction = isFunction(callback) ? callback : noop;
		if (win.webkitNotifications && win.webkitNotifications.checkPermission) {
			/*
			 * Chrome 23 supports win.Notification.requestPermission, but it
			 * breaks the browsers, so use the old-webkit-prefixed 
			 * win.webkitNotifications.checkPermission instead.
			 *
			 * Firefox with html5notifications plugin supports this method
			 * for requesting permissions.
			 */
			win.webkitNotifications.requestPermission(callbackFunction);
		} else if (win.Notification && win.Notification.requestPermission) {
			win.Notification.requestPermission(callbackFunction);
		}
	}
	function permissionLevel() {
		var permission;
		if (!isSupported) { return; }
		if (win.Notification && win.Notification.permissionLevel) {
			//Safari 6
			permission = win.Notification.permissionLevel();
		} else if (win.webkitNotifications && win.webkitNotifications.checkPermission) {
			//Chrome & Firefox with html5-notifications plugin installed
			permission = PERMISSION[win.webkitNotifications.checkPermission()];
		} else if (navigator.mozNotification) {
			//Firefox Mobile
			permission = PERMISSION_GRANTED;
		} else if (win.Notification && win.Notification.permission) {
			// Firefox 23+
			permission = win.Notification.permission;
		} else if (win.external && (win.external.msIsSiteMode() !== undefined)) { /* keep last */
			//IE9+
			permission = win.external.msIsSiteMode() ? PERMISSION_GRANTED : PERMISSION_DEFAULT;
		}
		return permission;
	}
	/**
	 *  
	 */
	function config(params) {
		if (params && isObject(params)) {
			mixin(settings, params);
		}
		return settings;
	}
	function isDocumentHidden() {
		return settings.pageVisibility ? (document.hidden || document.msHidden || document.mozHidden || document.webkitHidden) : true;
	}
	function createNotification(title, options) {
		var notification,
			notificationWrapper;
		/*
			Return undefined if notifications are not supported.

			Return undefined if no permissions for displaying notifications.

			Title and icons are required. Return undefined if not set.
		 */
		if (isSupported && isDocumentHidden() && isString(title) && (options && (isString(options.icon) || isObject(options.icon))) && (permissionLevel() === PERMISSION_GRANTED)) {
			notification = getNotification(title, options);
		}
		notificationWrapper = getWrapper(notification);
		//Auto-close notification
		if (settings.autoClose!=0 && notification && !notification.ieVerification && notification.addEventListener) {
			notification.addEventListener("show", function () {
				var notification = notificationWrapper;
				win.setTimeout(function () {
					notification.close();
				}, settings.autoClose);
			});
		}
		return notificationWrapper;
	}
	win.notify = {
		PERMISSION_DEFAULT: PERMISSION_DEFAULT,
		PERMISSION_GRANTED: PERMISSION_GRANTED,
		PERMISSION_DENIED: PERMISSION_DENIED,
		isSupported: isSupported,
		config: config,
		createNotification: createNotification,
		permissionLevel: permissionLevel,
		requestPermission: requestPermission
	};
	if (isFunction(Object.seal)) {
		Object.seal(win.notify);
	}
}(window));

/*{+END}*/
