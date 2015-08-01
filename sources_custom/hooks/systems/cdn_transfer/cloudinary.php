<?php

class Hook_cdn_transfer_cloudinary
{
    /**
     * Find whether the hook is enabled.
     *
     * @return boolean Whether it is
     */
    public function is_enabled()
    {
        $cloud_name = get_option('cloudinary_cloud_name');
        $api_key = get_option('cloudinary_api_key');
        $api_secret = get_option('cloudinary_api_secret');
        if (empty($cloud_name)) {
            return false;
        }
        if (empty($api_key)) {
            return false;
        }
        if (empty($api_secret)) {
            return false;
        }

        if ((get_option('cloudinary_test_mode') == '1') && (get_param_integer('keep_cloudinary', 0) == 0)) {
            return false;
        }

        return true;
    }

    /**
     * Converts an uploaded file into a URL, by moving it to an appropriate place on the CDN.
     *
     * @param  ID_TEXT $attach_name The name of the HTTP file parameter storing the upload.
     * @param  ID_TEXT $upload_folder The folder name in uploads/ where we would normally put this upload, if we weren't transferring it to the CDN
     * @param  string $filename Filename to upload with. May not be respected, depending on service implementation
     * @param  integer $obfuscate Whether to obfuscate file names so the URLs can not be guessed/derived (0=do not, 1=do, 2=make extension .dat as well)
     * @set    0 1 2
     * @param  boolean $accept_errors Whether to accept upload errors
     * @return ?array A pair: the URL and the filename (NULL: did nothing)
     */
    public function transfer_upload($attach_name, $upload_folder, $filename, $obfuscate = 0, $accept_errors = false)
    {
        $cloud_name = get_option('cloudinary_cloud_name');
        $api_key = get_option('cloudinary_api_key');
        $api_secret = get_option('cloudinary_api_secret');

        $dirs = explode("\n", get_option('cloudinary_transfer_directories'));
        if (!in_array($upload_folder, $dirs)) {
            return null;
        }

        // Proceed...

        safe_ini_set('ocproducts.type_strictness', '0');

        require_code('Cloudinary/Cloudinary');
        require_code('Cloudinary/Uploader');

        \Cloudinary::config(array(
            'cloud_name' => $cloud_name,
            'api_key' => $api_key,
            'api_secret' => $api_secret,
        ));

        $tags = array(
            $GLOBALS['FORUM_DRIVER']->get_username(get_member()),
            get_site_name(),
            get_zone_name(),
            get_page_name(),
        );

        $options = array(
            'resource_type' => 'auto',
            'tags' => $tags,
            'angle' => 'exif',
        );

        if ($obfuscate != 0) {
            $options['public_id'] = $upload_folder . '/' . preg_replace('#\.[^\.]*$#', '', $filename);
        } else {
            $options['use_filename'] = true;
            $options['unique_filename'] = true;
        }

        $filearrays = array();
        get_upload_filearray($attach_name, $filearrays);

        try {
            $result = \Cloudinary\Uploader::upload(
                $filearrays[$attach_name]['tmp_name'],
                $options
            );
        } catch (Exception $e) {
            if ($accept_errors) {
                attach_message($e->getMessage(), 'warn');
                return false;
            }
            warn_exit($e->getMessage());
        }

        if (strpos(get_base_url(), 'https://') === false) {
            $url = $result['url'];
        } else {
            $url = $result['secure_url'];
        }
        return $url;
    }

    // IDEA: Support deletion. This is hard though, as we would need to track upload ownership somewhere or uniqueness (else temporary URL "uploads" could be used as a vector to hijack other people's original uploads).
}
