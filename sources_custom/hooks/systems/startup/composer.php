<?php

/**
 * Hook class.
 */
class Hook_startup_composer
{
    public function run()
    {
        if (is_file(get_file_base() . '/vendor/autoload.php')) {
            require(get_file_base() . '/vendor/autoload.php');
        }
    }
}
