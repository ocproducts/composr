/* TODO: Salman merge into activity_feed.js */

'use strict';

// Assume that our activity feed needs updating to start with
if (window.latest_activity === undefined) {
    window.latest_activity = 0;
    window.s_ajax_update_locking = 0;
    window.activities_feed_grow = true;
}

function sUpdateGetData() {
    // Lock feed updates by setting s_ajax_update_locking to 1
    if ((++window.s_ajax_update_locking) > 1) {
        window.s_ajax_update_locking = 1;
    } else {
        // First we check whether our feed is already up to date
        jQuery.ajax({
            url: $cms.baseUrl('data_custom/latest_activity.txt?chrome_fix=' + Math.floor(Math.random() * 10000)),
            data: {},
            success: function (data) {
                if (window.parseInt(data) != window.latest_activity) {
                    // If not then remember the new value
                    window.latest_activity = window.parseInt(data);

                    // Now grab whatever updates are available
                    var url = $cms.baseUrl('data_custom/activities_updater.php' + $cms.keepStub(true)),
                        listElements = jQuery('li', '#activities_feed'),
                        lastId = ((typeof listElements.attr('id') == 'undefined') ? '-1' : listElements.attr('id').replace(/^activity_/, '')),
                        postVal = 'last_id=' + lastId + '&mode=' + window.activities_mode;

                    if ((window.activities_member_ids != null) && (window.activities_member_ids !== '')) {
                        postVal = postVal + '&member_ids=' + window.activities_member_ids;
                    }

                    postVal += '&csrf_token=' + encodeURIComponent($cms.getCsrfToken()); // For CSRF prevention

                    jQuery.ajax({
                        url: url,
                        type: 'POST',
                        data: postVal,
                        cache: false,
                        timeout: 5000,
                        success: function (data, stat) {
                            sUpdateShow(data, stat);
                        },
                        error: function (a, stat, err) {
                            sUpdateShow(err, stat);
                        }
                    });
                } else {
                    // Allow feed updates
                    window.s_ajax_update_locking = 0;
                }
            },
            dataType: 'text'
        });
    }
}

/**
 * Receive and parse data for the activities activities feed
 */
function sUpdateShow(data, stat) {
    if (window.s_ajax_update_locking > 1) {
        window.s_ajax_update_locking = 1;
    } else {
        var succeeded = false;
        if (stat == 'success') {
            if (jQuery('success', data).text() == '1') {
                var listElements = jQuery('li', '#activities_feed'); // Querying from current browser DOM
                var listItems = jQuery('listitem', data); // Querying from XML definition o new data

                listElements.removeAttr('toFade');

                // Add in new items
                var topOfList = document.getElementById('activities_holder').firstChild;
                jQuery.each(listItems, function () {
                    var thisLi = document.createElement('li');
                    thisLi.id = 'activity_' + jQuery(this).attr('id');
                    thisLi.className = 'activities_box box';
                    thisLi.setAttribute('toFade', 'yes');
                    topOfList.parentNode.insertBefore(thisLi, topOfList);
                    $cms.dom.html(thisLi, window.Base64.decode(jQuery(this).text()));
                });

                var noMessages = document.getElementById('activity_-1');
                if (noMessages) noMessages.style.display = 'none';

                listElements = jQuery('li', '#activities_feed'); // Refresh, so as to include the new activity nodes

                if ((!window.activities_feed_grow) && (listElements.length > window.activities_feed_max)) // Remove anything passed the grow length
                {
                    for (var i = window.activities_feed_max; i < listElements.length; i++) {
                        listElements.last().remove();
                    }
                }

                jQuery('#activities_general_notify').text('');
                jQuery('li[toFade="yes"]', '#activities_feed').hide().fadeIn(1200);
                succeeded = true;
            } else {
                if (jQuery('success', data).text() == '2') {
                    jQuery('#activities_general_notify').text('');
                    succeeded = true;
                }
            }
        }
        if (!succeeded) {
            jQuery('#activities_general_notify').text('{!INTERNAL_ERROR;^}');
        }
        window.s_ajax_update_locking = 0;
    }
}

function sUpdateRemove(event, id) {
    $cms.ui.confirm(
        '{!activities:DELETE_CONFIRM;^}',
        function (result) {
            if (result) {
                var url = $cms.baseUrl('data_custom/activities_removal.php' + $cms.keepStub(true));

                var postVal = 'removal_id=' + id;
                postVal += '&csrf_token=' + encodeURIComponent($cms.getCsrfToken()); // For CSRF prevention

                jQuery.ajax({
                    url: url,
                    type: 'POST',
                    data: postVal,
                    cache: false,
                    timeout: 5000,
                    success: function (data, stat) {
                        sUpdateRemoveShow(data, stat);
                    },
                    error: function (a, stat, err) {
                        sUpdateRemoveShow(err, stat);
                    }
                });
            }
        }
    );
    event.preventDefault();
}

function sUpdateRemoveShow(data, stat) {
    var succeeded = false;
    var statusId = '';

    var animationSpeed = 1600;

    if (stat == 'success') {
        if (jQuery('success', data).text() == '1') {
            statusId = '#activity_' + jQuery('status_id', data).text();
            jQuery('.activities_content', statusId, '#activities_feed').text(jQuery('feedback', data).text()).addClass('activities_content__remove_success').hide().fadeIn(animationSpeed, function () {
                jQuery(statusId, '#activities_feed').fadeOut(animationSpeed, function () {
                    jQuery(statusId, '#activities_feed').remove();
                });
            });
        } else {
            switch (jQuery('err', data).text()) {
                case 'perms':
                    statusId = '#activity_' + jQuery('status_id', data).text();
                    var backupUpText = jQuery('activities_content', statusId, '#activities_feed').text();
                    jQuery('.activities_content', statusId, '#activities_feed').text(jQuery('feedback', data).text()).addClass('activities_content__remove_failure').hide().fadeIn(animationSpeed, function () {
                        jQuery('.activities_content', statusId, '#activities_feed').fadeOut(animationSpeed, function () {
                            jQuery('.activities_content', statusId, '#activities_feed').text(backupUpText).removeClass('activities_content__remove_failure').fadeIn(animationSpeed);
                        });
                    });
                    break;
                case 'missing':
                default:
                    break;
            }
        }
    }
}
