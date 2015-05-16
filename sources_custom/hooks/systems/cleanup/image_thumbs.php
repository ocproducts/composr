<?php

/**
 * Hook class.
 */
class Hook_image_thumbs
{
    /**
     * Find details about this cleanup hook.
     *
     * @return ?array Map of cleanup hook info (null: hook is disabled).
     */
    public function info()
    {
        return null; // Disabled if thumbnails are controlled manually
    }
}
