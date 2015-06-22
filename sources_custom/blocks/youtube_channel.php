<?php

/**
 * Licensed under Creative Commons Attribution 3.0 license (CC BY 3.0).  You are free to use, distribute, and modify as you wish.
 * Thanks to stackoverflow.com for leading me to the code needed to pull and process data from the YouTube API.
 * The stackoverflow.com post with this info is here:
 *    http://stackoverflow.com/questions/9902210/php-youtube-latest-video-feed-php-code-mechanism
 */
/*EXTRA FUNCTIONS: json_decode*/

/**
 * Block class.
 */
class Block_youtube_channel
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled).
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Jason Verhagen';
        $info['organisation'] = 'HolleywoodStudio.com';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 9;
        $info['locked'] = false;
        $info['update_require_upgrade'] = 1;
        $info['parameters'] = array('name', 'title', 'template_main', 'template_style', 'start_video', 'max_videos', 'orderby', 'embed_allowed', 'show_player', 'player_align', 'player_width', 'player_height', 'style', 'nothumbplayer', 'thumbnail', 'formorelead', 'formoretext', 'formoreurl');
        return $info;
    }

    /**
     * Find caching details for the block.
     *
     * @return ?array Map of cache details (cache_on and ttl) (null: block is disabled).
     */
    public function caching_environment()
    {
        $info = array();
        $info['cache_on'] = array('block_youtube_channel__cache_on');
        $info['ttl'] = intval(get_option('channel_update_time'));
        return $info;
    }

    /**
     * Execute the block.
     *
     * @param  array $map A map of parameters.
     * @return tempcode The result of execution.
     */
    public function run($map)
    {
        i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

        //set up variables from parameters
        $channel_name = array_key_exists('name', $map) ? $map['name'] : 'holleywoodstudio';
        $channel_title = array_key_exists('title', $map) ? $map['title'] : '';
        $channel_tempmain = array_key_exists('template_main', $map) ? $map['template_main'] : '';
        if ($channel_tempmain) {
            $channel_tempmain = '_' . $channel_tempmain;
        }
        $channel_templatemain = 'BLOCK_YOUTUBE_CHANNEL' . $channel_tempmain;
        $channel_tempstyle = array_key_exists('template_style', $map) ? $map['template_style'] : '';
        if ($channel_tempstyle) {
            $channel_tempstyle = '_' . $channel_tempstyle;
        }
        $channel_templatestyle = 'BLOCK_YOUTUBE_CHANNEL_STYLE' . $channel_tempstyle;
        $channel_startvideo = array_key_exists('start_video', $map) ? $map['start_video'] : '1';
        $channel_maxvideos = array_key_exists('max_videos', $map) ? $map['max_videos'] : '25';
        $channel_orderby = array_key_exists('orderby', $map) ? $map['orderby'] : '1';
        $channel_showplayer = array_key_exists('show_player', $map) ? $map['show_player'] : '1';
        $channel_embedallowed = array_key_exists('embed_allowed', $map) ? $map['embed_allowed'] : '1';
        $channel_playeralign = strtolower(array_key_exists('player_align', $map) ? $map['player_align'] : 'center');
        $channel_playerwidth = array_key_exists('player_width', $map) ? $map['player_width'] : '480';
        $channel_playerheight = array_key_exists('player_height', $map) ? $map['player_height'] : '270';
        $channel_style = array_key_exists('style', $map) ? $map['style'] : '1';
        $channel_nothumbplayer = array_key_exists('nothumbplayer', $map) ? $map['nothumbplayer'] : '0';
        $channel_formorelead = array_key_exists('formorelead', $map) ? $map['formorelead'] : '';
        $channel_formoretext = array_key_exists('formoretext', $map) ? $map['formoretext'] : '';
        $channel_formoreurl = array_key_exists('formoreurl', $map) ? $map['formoreurl'] : '';
        $channel_url = 'http://www.youtube.com/user/' . $channel_name;
        $channel_thumbnail = array_key_exists('thumbnail', $map) ? $map['thumbnail'] : '0';

        //create some working variables for working in foreach loop
        $temp_showplayer = $channel_showplayer;
        $temp_nothumbplayer = $channel_nothumbplayer;

        //set blank variable that can be set to an error message.
        $channel_error = '';

        //sanity checks on some critical input - if out of range or unknown values are detected, set them to a default value
        if ($channel_startvideo < 1) {
            $channel_startvideo = 1;
        }
        if ($channel_maxvideos < 1 || $channel_maxvideos > 50) {
            $channel_maxvideos = 25;
        }
        if ($channel_orderby < 1 || $channel_orderby > 3) {
            $channel_orderby = 1;
        }
        if ($channel_showplayer < 0 || $channel_showplayer > 2) {
            $channel_showplayer = 1;
        }
        if ($channel_playeralign != 'center' || $channel_playeralign != 'left' || $channel_playeralign != 'right') {
            $channel_playeralign = 'center';
        }
        //if ($channel_style<1 || $channel_style>3) $channel_style=1;
        if ($channel_nothumbplayer < 0 || $channel_nothumbplayer > 1) {
            $channel_nothumbplayer = 0;
        }

        //if orderby is specified, YouTube API may return cached results.  Default for channel feed is to return results ordered by published date.
        //We don't want cached results from API for default orderby, so we don't pass the orderby for published date and only pass it when ordering by view count or rating.
        //
        //Set default API request string
        $api_v2 = "http://gdata.youtube.com/feeds/api/users/$channel_name/uploads?max-results=$channel_maxvideos&start-index=$channel_startvideo&v=2";
        //If orderby parameter is set to 2, set API request string for viewCount
        if ($channel_orderby == '2') {
            $orderby = 'viewCount';
            $api_v2 = "http://gdata.youtube.com/feeds/api/users/$channel_name/uploads?max-results=$channel_maxvideos&start-index=$channel_startvideo&orderby=$orderby&v=2";
        }
        //If orderby parameter is set to 3, set API request string for rating
        if ($channel_orderby == '3') {
            $orderby = 'rating';
            $api_v2 = "http://gdata.youtube.com/feeds/api/users/$channel_name/uploads?max-results=$channel_maxvideos&start-index=$channel_startvideo&orderby=$orderby&v=2";
        }

        $content = new Tempcode();

        //$i will count the iterations through the foreach loop
        $i = 1;

        //load YouTube API JSON request into $result so we can check if we actually get a usable result and set an error if we don't get a usable result
        $result = json_decode(@file_get_contents(strval($api_v2) . '&alt=json'));

        //if we get a usable result, parse out the meta information for each video and pass it to the style template
        if (isset($result->feed->entry)) {
            foreach ($result->feed->entry as $entry) {
                // meta information for the video
                //get video title
                if (isset($entry->title->{'$t'})) {
                    $title = $entry->title->{'$t'};
                } else {
                    $title = '';
                }

                //get video description
                if (isset($entry->{'media$group'}->{'media$description'}->{'$t'})) {
                    $description = $entry->{'media$group'}->{'media$description'}->{'$t'};
                } else {
                    $description = '';
                }

                //get video view count
                if (isset($entry->{'yt$statistics'}->viewCount)) {
                    $views = $entry->{'yt$statistics'}->viewCount;
                } else {
                    $views = strval(0);
                }

                //get video favorite count
                if (isset($entry->{'yt$statistics'}->favoriteCount)) {
                    $favoritecount = $entry->{'yt$statistics'}->favoriteCount;
                } else {
                    $favoritecount = strval(0);
                }

                $thumbnails = $entry->{'media$group'}->{'media$thumbnail'};        //get video thumbnails
                $accesscontrols = $entry->{'yt$accessControl'};                        //get video access controls - used to find out if video can be embedded
                $vidurl = $entry->{'media$group'}->{'media$player'};                //get video youtube page url
                $uploaded = $entry->{'media$group'}->{'yt$uploaded'}->{'$t'};        //get video upload date/time
                $video_id = $entry->{'media$group'}->{'yt$videoid'}->{'$t'};        //get video ID

                if (isset($entry->{'yt$rating'})) {
                    $likes = $entry->{'yt$rating'}->numLikes;
                }        //if video has been liked, get number of likes
                else {
                    $likes = 0;
                }                                                                    //if video has no likes, node will not be available - manually set it to 0

                if (isset($entry->{'yt$rating'})) {
                    $dislikes = $entry->{'yt$rating'}->numDislikes;
                }    //if video has been disliked, get number of dislikes
                else {
                    $dislikes = 0;
                }                                                                //if video has no dislikes, node will not be available - manually set it to 0

                $ratingstotal = $likes + $dislikes;                                        //generate total number of likes and dislikes
                if ($ratingstotal > 0) {
                    $likespercent = intval(round(($likes / $ratingstotal) * 100));
                }            //generate percentage of likes
                else {
                    $likespercent = 0;
                }                                                        //if no likes or dislikes, set percentage of likes to 0

                if (isset($entry->{'gd$rating'})) {
                    $rating = $entry->{'gd$rating'}->average;
                }        //if video has likes or dislikes, get the average rating (can be used for half star ratings of 1 to 5 stars)
                else {
                    $rating = 0;
                }                                                                //if video has no likes or dislikes, node will not be available - manually set rating is set to 0
                if ($rating > 0) {
                    $ratingstars = intval(round($rating));
                }                //generate full star rating of 1 to 5 stars (no half stars)
                else {
                    $ratingstars = 0;
                }                                                            //if no likes or dislikes, set full star rating to 0

                $minutes = 0;
                $seconds = 0;                                                        //initialize minutes and seconds to 0
                $seconds = $entry->{'media$group'}->{'yt$duration'}->seconds;        //get video duration in seconds
                if ($seconds > 1) {
                    $duration_text = "$seconds seconds";
                }                    //if more than one second, use plural - seconds
                else {
                    $duration_text = "$seconds second";
                }                                    //if only one second, use singular - second

                //check the permission to see if embedding is allowed for video
                $allowembedding = '0';
                foreach ($accesscontrols as $accesscontrol) {
                    if (($accesscontrol->{'action'} == 'embed') && ($accesscontrol->{'permission'} == 'allowed')) {
                        $allowembedding = '1';
                    }
                }

                //if video is more than 59 seconds, use minutes and seconds, and distinguish between singular and plural for both seconds and minutes.
                if ($seconds > 59) {
                    $minutes = intval(floor($seconds / 60));
                    $seconds = $seconds - ($minutes * 60);
                    if ($minutes > 1) {
                        $minutes_text = 'minutes';
                    } else {
                        $minutes_text = 'minute';
                    }
                    if ($seconds > 1) {
                        $seconds_text = 'seconds';
                    } else {
                        $seconds_text = 'second';
                    }
                    if ($seconds == 0) {
                        $duration_text = "$minutes $minutes_text";
                    } else {
                        $duration_text = "$minutes $minutes_text, $seconds $seconds_text";
                    }
                }

                //prepend zero(s) to minutes, if needed, when using numeric time format so we have 2-digit format
                if ($minutes < 1) {
                    $minutes = '00';
                } elseif ($minutes > 0 && $minutes < 10) {
                    $minutes = '0' . strval($minutes);
                }

                //prepend zero(s) to seconds, if needed, when using numeric time format so we have 2-digit format
                if ($seconds < 1) {
                    $seconds = '00';
                } elseif ($seconds > 0 && $seconds < 10) {
                    $seconds = '0' . strval($seconds);
                }

                $duration_numeric = "$minutes:$seconds";                                        //generate numeric time format mm:ss

                $embedvideo = 'http://www.youtube.com/embed/' . $video_id;                    //generate embedded video player url

                //generate the iframe YouTube Player embed code
                $videoplayer = "<iframe width=\"$channel_playerwidth\" height=\"$channel_playerheight\" src=\"$embedvideo\" frameborder=\"0\" allowfullscreen></iframe>";

                // few different thumbnail image choice here:
                //   0 => default image, low res - "default"
                //   1 => default image, medium res - "mqdefault"
                //   2 => default image, higher res - "hqdefault"
                //   3 => beginning of vid, low res - "start"
                //   4 => middle of vid, low res - "middle"
                //   5 => end of vid, low res - "end"
                $thumb_img = $thumbnails[$channel_thumbnail];
                $thumb_img_0 = $thumbnails[0];
                $thumb_img_1 = $thumbnails[1];
                $thumb_img_2 = $thumbnails[2];
                $thumb_img_3 = $thumbnails[3];
                $thumb_img_4 = $thumbnails[4];
                $thumb_img_5 = $thumbnails[5];
                $thumbalt = $thumb_img->{'yt$name'};
                $thumbalt_0 = $thumb_img_0->{'yt$name'};
                $thumbalt_1 = $thumb_img_1->{'yt$name'};
                $thumbalt_2 = $thumb_img_2->{'yt$name'};
                $thumbalt_3 = $thumb_img_3->{'yt$name'};
                $thumbalt_4 = $thumb_img_4->{'yt$name'};
                $thumbalt_5 = $thumb_img_5->{'yt$name'};

                //if show player parameter is greater than 0, pass SHOWPLAYER set to 1 to template.
                if ($temp_showplayer > 0 && $i <= $temp_showplayer) {
                    $channel_showplayer = '1';
                } else {
                    $channel_showplayer = '0';
                }

                //Disable thumbnail when player is enabled, enable thumbnail when player is disabled.
                if ($temp_nothumbplayer == 0 && $channel_showplayer == 1) {
                    $channel_nothumbplayer = '0';
                }
                if ($temp_nothumbplayer == 0 && $channel_showplayer == 0) {
                    $channel_nothumbplayer = '1';
                }

                //style all of the meta info using the Style template and store it all in the content variable which is passed to the main template
                $content->attach(do_template($channel_templatestyle, array(
                    'EMBED_ALLOWED' => $channel_embedallowed,
                    'EMBEDPLAYER_ALLOWED' => $allowembedding,
                    'VIDEO_ID' => $video_id,
                    'MAX_VIDEOS' => $channel_maxvideos,
                    'COUNT' => strval($i),
                    'VIDEO_URL' => $vidurl->url,
                    'CHANNEL_TITLE' => $channel_title,
                    'VIDEO_TITLE' => $title,
                    'RATING_STARS' => strval($ratingstars),
                    'RATING_LIKE_PERCENT' => strval($likespercent),
                    'RATING_NUM_RATES' => strval($ratingstotal),
                    'RATING_DISLIKES' => strval($dislikes),
                    'RATING_LIKES' => strval($likes),
                    'RATING_NUMERIC' => strval($rating),
                    'FAVORITE_COUNT' => strval($favoritecount),
                    'CHANNEL_URL' => $channel_url,
                    'CHANNEL_NAME' => $channel_name,
                    'UPLOAD_DATE' => $uploaded,
                    'DESCRIPTION' => $description,
                    'VIEWS' => $views,
                    'DURATION_TEXT' => $duration_text,
                    'DURATION_NUMERIC' => $duration_numeric,
                    'THUMBNAIL' => $thumb_img->url,
                    'THUMBWIDTH' => strval($thumb_img->width),
                    'THUMBHEIGHT' => strval($thumb_img->height),
                    'THUMBALT' => $thumbalt,
                    'THUMBNAIL_0' => $thumb_img_0->url,
                    'THUMBWIDTH_0' => strval($thumb_img_0->width),
                    'THUMBHEIGHT_0' => strval($thumb_img_0->height),
                    'THUMBALT_0' => $thumbalt_0,
                    'THUMBNAIL_1' => $thumb_img_1->url,
                    'THUMBWIDTH_1' => strval($thumb_img_1->width),
                    'THUMBHEIGHT_1' => strval($thumb_img_1->height),
                    'THUMBALT_1' => $thumbalt_1,
                    'THUMBNAIL_2' => $thumb_img_2->url,
                    'THUMBWIDTH_2' => strval($thumb_img_2->width),
                    'THUMBHEIGHT_2' => strval($thumb_img_2->height),
                    'THUMBALT_2' => $thumbalt_2,
                    'THUMBNAIL_3' => $thumb_img_3->url,
                    'THUMBWIDTH_3' => strval($thumb_img_3->width),
                    'THUMBHEIGHT_3' => strval($thumb_img_3->height),
                    'THUMBALT_3' => $thumbalt_3,
                    'THUMBNAIL_4' => $thumb_img_4->url,
                    'THUMBWIDTH_4' => strval($thumb_img_4->width),
                    'THUMBHEIGHT_4' => strval($thumb_img_4->height),
                    'THUMBALT_4' => $thumbalt_4,
                    'THUMBNAIL_5' => $thumb_img_5->url,
                    'THUMBWIDTH_5' => strval($thumb_img_5->width),
                    'THUMBHEIGHT_5' => strval($thumb_img_5->height),
                    'THUMBALT_5' => $thumbalt_5,
                    'PLAYERALIGN' => $channel_playeralign,
                    'PLAYERHEIGHT' => $channel_playerheight,
                    'PLAYERWIDTH' => $channel_playerwidth,
                    'EMBEDVIDEO' => $embedvideo,
                    'VIDEO_PLAYER' => $videoplayer,
                    'SHOWPLAYER' => $channel_showplayer,
                    'STYLE' => strval($channel_style),
                    'NOTHUMBPLAYER' => $channel_nothumbplayer,
                    'FOR_MORE_LEAD' => $channel_formorelead,
                    'FOR_MORE_TEXT' => $channel_formoretext,
                    'FOR_MORE_URL' => $channel_formoreurl
                )));

                $i++;
            }
        } else {
            $channel_error = 'Channel not found or possibly the YouTube API request limit is exceded!';
        }    //set error if channel request doesn't return a channel result

        //send styled content to the main template
        return do_template($channel_templatemain, array(
            'CHANNEL_ERROR' => $channel_error,
            'CHANNEL_TITLE' => $channel_title,
            'CHANNEL_NAME' => $channel_name,
            'CHANNEL_URL' => $channel_url,
            'CONTENT' => $content,
        ));
    }
}

/**
 * Find the cache signature for the block.
 *
 * @param  array $map The block parameters.
 * @return array The cache signature.
 */
function block_youtube_channel__cache_on($map)
{
    return array(array_key_exists('max_videos', $map) ? intval($map['max_videos']) : 25, array_key_exists('start_video', $map) ? intval($map['start_video']) : 1, array_key_exists('orderby', $map) ? intval($map['orderby']) : 1, array_key_exists('embed_player', $map) ? intval($map['embed_player']) : 1, array_key_exists('show_player', $map) ? intval($map['show_player']) : 1, array_key_exists('style', $map) ? intval($map['style']) : 1, array_key_exists('nothumbplayer', $map) ? intval($map['nothumbplayer']) : 0, array_key_exists('thumbnail', $map) ? intval($map['thumbnail']) : 0, array_key_exists('player_width', $map) ? intval($map['player_width']) : 480, array_key_exists('player_height', $map) ? intval($map['player_height']) : 270, array_key_exists('title', $map) ? $map['title'] : '', array_key_exists('player_align', $map) ? $map['player_align'] : 'center', array_key_exists('formorelead', $map) ? $map['formorelead'] : '', array_key_exists('formoretext', $map) ? $map['formoretext'] : '', array_key_exists('formoreurl', $map) ? $map['formoreurl'] : '', array_key_exists('name', $map) ? $map['name'] : 'holleywoodstudio', array_key_exists('template_main', $map) ? $map['template_main'] : '', array_key_exists('template_style', $map) ? $map['template_style'] : '');
}
