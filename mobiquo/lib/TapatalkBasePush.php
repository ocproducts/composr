<?php

/*NO_API_CHECK*/
/*CQC: No check*/

/**
 * push base class
 * 
 * @since  2013-7-10
 * @author Wu ZeTao <578014287@qq.com>
 */
Abstract Class TapatalkBasePush {
    
    protected $childReference;

    protected $pushStatus = false; //judged by push flags in config/settings and curl_init,allow_url_fopen
    protected $pushKey = '';
    protected $slugData = array();  //default is empty array
    protected $imActive = false;    //judge current user is active user by tapatalk_push_user table
    protected $siteUrl;
    protected $supportedPushType = array();
    
    //init
    public function __construct($ref) {
        $this->childReference = $ref;
    }
    public function push_clean($str)
    {
        $str = strip_tags($str);
        $str = trim($str);
        return html_entity_decode($str, ENT_QUOTES, 'UTF-8');
    }

    /**
     * wrap method invoking from outside.
     * this method should be the only entry from outside for sending push,because other methods maybe have not been implemented,this entry methond can prevent the error occuring
     * if the corresponding method has not been implemented,then will do nothing
     *
     * @params  String  $methodName
     * @params  Array  $p  params should be transmitted to the corresponding method
     * There are only several methods can be called,they should be protected methods:
        doAfterAppLogin()   record user info after user login from app
        sendSubPush()
        sendPmPush()
        sendConvPush()
        sendLikePush()
        sendThankPush()
        sendQuotePush()
        sendTagPush()
        sendNewtopicPush()
     */
    public function push_slug($push_v, $method = 'NEW')
    {
        if(empty($push_v))
            $push_v = serialize(array());
        $push_v_data = unserialize($push_v);
        $current_time = time();
        if(!is_array($push_v_data))
            return serialize(array(2 => 0, 3 => 'Invalid v data', 5 => 0));
        if($method != 'CHECK' && $method != 'UPDATE' && $method != 'NEW')
            return serialize(array(2 => 0, 3 => 'Invalid method', 5 => 0));

        if($method != 'NEW' && !empty($push_v_data))
        {
            $push_v_data[8] = $method == 'UPDATE';
            if($push_v_data[5] == 1)
            {
                if($push_v_data[6] + $push_v_data[7] > $current_time)
                    return $push_v;
                else
                    $method = 'NEW';
            }
        }

        if($method == 'NEW' || empty($push_v_data))
        {
            $push_v_data = array();     //Slug
            $push_v_data[0] = 3;        //        $push_v_data['max_times'] = 3;                //max push failed attempt times in period
            $push_v_data[1] = 300;      //        $push_v_data['max_times_in_period'] = 300;     //the limitation period
            $push_v_data[2] = 1;        //        $push_v_data['result'] = 1;                   //indicate if the output is valid of not
            $push_v_data[3] = '';       //        $push_v_data['result_text'] = '';             //invalid reason
            $push_v_data[4] = array();  //        $push_v_data['stick_time_queue'] = array();   //failed attempt timestamps
            $push_v_data[5] = 0;        //        $push_v_data['stick'] = 0;                    //indicate if push attempt is allowed
            $push_v_data[6] = 0;        //        $push_v_data['stick_timestamp'] = 0;          //when did push be sticked
            $push_v_data[7] = 600;      //        $push_v_data['stick_time'] = 600;             //how long will it be sticked
            $push_v_data[8] = 1;        //        $push_v_data['save'] = 1;                     //indicate if you need to save the slug into db
            return serialize($push_v_data);
        }

        if($method == 'UPDATE')
        {
            $push_v_data[4][] = $current_time;
        }
        $sizeof_queue = count($push_v_data[4]);

        $period_queue = $sizeof_queue > 1 ? ($push_v_data[4][$sizeof_queue - 1] - $push_v_data[4][0]) : 0;

        $times_overflow = $sizeof_queue > $push_v_data[0];
        $period_overflow = $period_queue > $push_v_data[1];

        if($period_overflow)
        {
            if(!array_shift($push_v_data[4]))
                $push_v_data[4] = array();
        }

        if($times_overflow && !$period_overflow)
        {
            $push_v_data[5] = 1;
            $push_v_data[6] = $current_time;
        }

        return serialize($push_v_data);
    }

    public function do_push_request($data, $pushTest = false)
    {
        $push_url = 'http://push.tapatalk.com/push.php';

        if (!class_exists('classTTConnection')){
            //if (!defined('IN_MOBIQUO')){
            //    define('IN_MOBIQUO', true);
            //}
            include_once(dirname(__FILE__) . '/classTTConnection.php');
        }

        if($pushTest){
            $connection = new classTTConnection();
            $connection->timeout = 5;
            $error = $connection->errors;
            return $connection->getContentFromSever($push_url, $data, 'post', false);
        }

        //Initial this key in modSettings

        //Get push_slug from db
        $push_slug = $this->childReference->get_push_slug();
        $push_slug = isset($push_slug) && !empty($push_slug) ? $push_slug : 0;

        $slug = $push_slug;
        $slug = self::push_slug($slug, 'CHECK');
        $check_res = unserialize($slug);

        //If it is valide(result = true) and it is not sticked, we try to send push
        if($check_res[2] && !$check_res[5])
        {
            //Slug is initialed or just be cleared
            if($check_res[8])
            {
                $this->childReference->set_push_slug($slug);
            }

            //Send push
            $connection = new classTTConnection();
            $connection->timeout = 5;
            $push_resp = $connection->getContentFromSever($push_url, $data, 'post', false);

            if(trim($push_resp) === 'Invalid push notification key') $push_resp = 1;
            if(!is_numeric($push_resp))
            {
                //Sending push failed, try to update push_slug to db
                $slug = self::push_slug($slug, 'UPDATE');
                $update_res = unserialize($slug);
                $update_res[3] = $push_resp;
                if($update_res[2] && $update_res[8])
                {
                    $this->childReference->set_push_slug(serialize($update_res));
                }
            }
        }

        return true;
    }
    
    public function getClientIp()
    {
        if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
            $ip = $_SERVER['HTTP_CLIENT_IP'];
        } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
        } else {
            $ip = $_SERVER['REMOTE_ADDR'];
        }
        return $ip;
    }
    
    public function getClientUserAgent()
    {
        $useragent = $_SERVER['HTTP_USER_AGENT'];
        return $useragent;
    }
    
    public function getIsFromApp()
    {
        return defined('IN_MOBIQUO') ? 1 : 0;
    }

    abstract function get_push_slug();
    abstract function set_push_slug($slug);
    
    public function callMethod($methodName, $p = NULL) {
        if (method_exists($this, $methodName)) {   //!!!
            if ($p)
                return $this->$methodName($p);
            else
                return $this->$methodName();
        }
    }
}
