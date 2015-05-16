<?php

function init__catalogues2($code)
{
    return str_replace('decache(\'main_cc_embed\');', 'decache(\'main_cc_embed\'); decache(\'main_google_map\');', $code);
}
