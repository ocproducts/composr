<?php

$url = "http://" . $_SERVER['HTTP_HOST'] . ":5280/http-bind/";

if (function_exists('set_time_limit')) {
    set_time_limit(300);
}

$content = (isset($_POST['post']) ? $_POST['post'] : file_get_contents("php://input")) . "\n";

/*
$debugfile="data/".rand().".xml";
file_put_contents($debugfile,"d: ".$content);
*/

$options = array(
    'http' => array(
        'method' => 'POST',
        'header' => "Accept-Encoding: gzip, deflate\nContent-Type: text/xml; charset=utf-8\nContent-length: " . strval(strlen($content)) . "\n",
        'content' => $content
    )
);
$context = stream_context_create($options);
@$result = file_get_contents($url, false, $context);
header($http_response_header[0]);
header("Access-Control-Allow-Origin: *");
header("Content-Type: text/xml");
/*
$debug=domDocument::loadXML($result);
if(!$debug){
echo "derfehler";
}
*/
if (strlen($result) == 0) {
    print_r($http_response_header);
}
//sleep(1);
echo $result;
