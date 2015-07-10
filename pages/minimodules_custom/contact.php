<?php

// TODO: Work in progress

$decision_tree = array(
    'start' => array(
        'title' => 'Support request - step 1',
        'form_method' => 'get',
        'questions' => array(
            'service_class' => array(
                'label' => 'What service class are you looking for?',
                'type' => 'list',
                'default' => 'Free community services',
                'default_list' => array(
                    'Free community services',
                    'Paid services',
                ),
                'options' => 'widget=radio',
                'required' => true,
            ),
        ),
        'next' => array(
            //    Parameter         Value                       Target
            array('service_class',  'Free community services',  'free'),
            array('service_class',  'Paid services',            'paid'),
        ),
    ),

    'free' => array(
        'title' => 'Free support request - step 2',
        'text' => 'Test.',
        'previous' => 'start',
        'expects_parameters' => array(
            'service_class',
        ),
        'questions' => array(
            'test' => array(
                'label' => 'Test',
                'description' => 'Test.',
                'type' => 'short_text',
                'default' => 'Test',
                'required' => false,
            ),
        ),
        'next' => 'http://example.com/',
    ),

    'paid' => array(
        'title' => 'Paid support request - step 2',
        'text' => 'Test.',
        'previous' => 'start',
        'notices' => array(
            'Test',
        ),
        'warnings' => array(
            'Test',
        ),
    ),
);

require_code('decision_tree');
$ob = new DecisionTree($decision_tree, 'start');
$tpl = $ob->run();
$tpl->evaluate_echo();
