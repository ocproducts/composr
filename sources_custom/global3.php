<?php

/**
 * Find whether we can get away with natural file access, not messing with AFMs, world-writability, etc.
 *
 * @return boolean Whether we have this
 */
function is_suexec_like()
{
    return false;
}

