<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * Standard code module initialisation function.
 */
function init__feedback()
{
    define('MAX_LIKES_TO_SHOW', 20);

    define('RATING_TYPE_star_choice', 0);
    define('RATING_TYPE_like_dislike', 1);

    global $RATINGS_STRUCTURE;
    $RATINGS_STRUCTURE = array(
        'catalogues__links' => array(
            RATING_TYPE_like_dislike,
            array(
                '' => '',
            )
        ),
        'images' => array(
            RATING_TYPE_star_choice,
            array(
                '' => 'General',
                'scenery' => 'Scenery',
                'quality' => 'Quality',
                'art' => 'Artiness',
            )
        ),
    );

    global $REVIEWS_STRUCTURE;
    $REVIEWS_STRUCTURE = array(
        'news' => array(
            'Informative',
            'Insightful',
        ),
    );
}
