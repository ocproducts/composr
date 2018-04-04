<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    testing_platform
 */

/**
 * Composr test case class (unit testing).
 */
class oembed_test_set extends cms_test_case
{
    public function testOEmbedManualPatternsConfigOption()
    {
        $map = array(
            'https://www.youtube.com/watch?v=GwbvoH6oh8s' => 'http://www.youtube.com/oembed',
            'https://vimeo.com/channels/staffpicks/247068452' => 'http://vimeo.com/api/oembed.{format}',
            'http://www.dailymotion.com/video/x6fdn40' => 'http://www.dailymotion.com/services/oembed',
            'http://www.slideshare.net/scroisier/future-of-open-source-cms-4176880' => 'http://www.slideshare.net/api/oembed/2',
            'https://www.flickr.com/photos/rustumlongpig/7168441953/in/photolist-bVs93M-76hEZ5-9k5TDH-7Mho7j-auaThL-21Kwz5k-e2dQPt-95ZsSS-7CaVss-adyb9W-cDUY87-4DmcLP-8t3qxh-nGpsmz-cyCMtL-brsL2j-61mdVx-acjjsR-aoBGSC-opyRb8-acUVnL-tXUqaM-gzXeG-5qU7mj-wbCGS-6hGPs3-8w3yy5-9ata57-qibN8N-c72zAW-7ada8L-3LxAzh-DJfuwT-4DVwX9-bneCT-4DVxsY-aoTLwD-6gxHP-obXG69-8rugxw-doaVy1-3LxCmd-4Kz14i-8DkL9d-6NDjdS-StTQEG-3LxzV5-qAyAB-caBL63-64c6ut' => 'http://www.flickr.com/services/oembed?format={format}',
            'https://www.instagram.com/p/BfzEfy-lK1N/?taken-by=kyliejenner' => 'http://api.instagram.com/oembed',
            'https://soundcloud.com/leletty/in-my-life-ill-love-you-more' => 'http://soundcloud.com/oembed?format={format}',
            'https://twitter.com/socpub/status/971009263702167553' => 'https://api.twitter.com/1/statuses/oembed.{format}',
            'https://www.facebook.com/zuck/posts/10102577175875681' => 'https://www.facebook.com/plugins/page/oembed.{format}/',
            'https://kaylinamari.tumblr.com/post/171185297937' => 'http://api.embed.ly/1/oembed?key=23e24bbf92db4442bacdf98f2c40b8fb',
            'http://edition.cnn.com/2009/HEALTH/04/06/hm.caffeine.withdrawal/index.html' => 'http://api.embed.ly/1/oembed?key=23e24bbf92db4442bacdf98f2c40b8fb',
            'https://www.google.co.uk/maps/@51.6921416,0.4606626,7z?hl=en' => 'http://api.embed.ly/1/oembed?key=23e24bbf92db4442bacdf98f2c40b8fb',
            'https://www.google.com/maps/@51.6921416,0.4606626,7z?hl=en' => 'http://api.embed.ly/1/oembed?key=23e24bbf92db4442bacdf98f2c40b8fb',
            'http://www.imdb.com/title/tt1825683/' => 'http://api.embed.ly/1/oembed?key=23e24bbf92db4442bacdf98f2c40b8fb',
            'https://www.scribd.com/document/372625296/PHP-docx' => 'http://api.embed.ly/1/oembed?key=23e24bbf92db4442bacdf98f2c40b8fb',
            'https://en.wikipedia.org/wiki/Windows_8' => 'http://api.embed.ly/1/oembed?key=23e24bbf92db4442bacdf98f2c40b8fb',
            'https://xkcd.com/1843/' => 'http://api.embed.ly/1/oembed?key=23e24bbf92db4442bacdf98f2c40b8fb',
        );

        foreach ($map as $url => $oembed_endpoint) {
            $_url = str_replace('{format}', 'json', $oembed_endpoint) . ((strpos($oembed_endpoint, '?') === false) ? '?' : '&') . 'url=' . urlencode($url);
            $c = http_get_contents($_url);
            $this->assertTrue(is_array(json_decode($c, true)), 'Failed on ' . str_replace('%', '%%', $_url));
        }
    }
}