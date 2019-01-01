<?php

$timeout = floatval($_GET['timeout']);
usleep(intval($timeout * 1000000.0));
