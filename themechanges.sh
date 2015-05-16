#!/bin/sh

echo "CSS/Template changes made in theme..."

find themes/*/css_custom -name "*.css" -exec sh -c 'if [ -f {}.editfrom ] ; then diff -u {}.editfrom {} ; else if [ -f themes/default/css/`basename {}` ] ; then diff -u themes/default/css/`basename {}` {} ; else diff -u themes/default/css_custom/`basename {}` {} ; fi ; fi' \;

find themes/*/templates_custom -name "*.tpl" -exec sh -c 'if [ -f {}.editfrom ] ; then diff -u {}.editfrom {} ; else if [ -f themes/default/templates/`basename {}` ] ; then diff -u themes/default/templates/`basename {}` {} ; else diff -u themes/default/templates_custom/`basename {}` {} ; fi ; fi' \;

find themes/*/javascript_custom -name "*.js" -exec sh -c 'if [ -f {}.editfrom ] ; then diff -u {}.editfrom {} ; else if [ -f themes/default/javascript/`basename {}` ] ; then diff -u themes/default/javascript/`basename {}` {} ; else diff -u themes/default/javascript_custom/`basename {}` {} ; fi ; fi' \;

find themes/*/xml_custom -name "*.xml" -exec sh -c 'if [ -f {}.editfrom ] ; then diff -u {}.editfrom {} ; else if [ -f themes/default/xml/`basename {}` ] ; then diff -u themes/default/xml/`basename {}` {} ; else diff -u themes/default/xml_custom/`basename {}` {} ; fi ; fi' \;

find themes/*/text_custom -name "*.txt" -exec sh -c 'if [ -f {}.editfrom ] ; then diff -u {}.editfrom {} ; else if [ -f themes/default/text/`basename {}` ] ; then diff -u themes/default/text/`basename {}` {} ; else diff -u themes/default/text_custom/`basename {}` {} ; fi ; fi' \;

echo "CSS/Template changes to default theme made since theme..."

find themes/*/css_custom -name "*.css" -exec sh -c 'if [ -f {}.editfrom ] ; then if [ -f themes/default/css/`basename {}` ] ; then diff -u {}.editfrom themes/default/css/`basename {}` ; else {}.editfrom diff -u themes/default/css_custom/`basename {}` ; fi ; fi' \;

find themes/*/templates_custom -name "*.tpl" -exec sh -c 'if [ -f {}.editfrom ] ; then if [ -f themes/default/templates/`basename {}` ] ; then diff -u {}.editfrom themes/default/templates/`basename {}` ; else {}.editfrom diff -u themes/default/templates_custom/`basename {}` ; fi ; fi' \;

find themes/*/javascript_custom -name "*.js" -exec sh -c 'if [ -f {}.editfrom ] ; then if [ -f themes/default/javascript/`basename {}` ] ; then diff -u {}.editfrom themes/default/javascript/`basename {}` ; else {}.editfrom diff -u themes/default/javascript_custom/`basename {}` ; fi ; fi' \;

find themes/*/xml_custom -name "*.xml" -exec sh -c 'if [ -f {}.editfrom ] ; then if [ -f themes/default/xml/`basename {}` ] ; then diff -u {}.editfrom themes/default/xml/`basename {}` ; else {}.editfrom diff -u themes/default/xml_custom/`basename {}` ; fi ; fi' \;

find themes/*/text_custom -name "*.txt" -exec sh -c 'if [ -f {}.editfrom ] ; then if [ -f themes/default/text/`basename {}` ] ; then diff -u {}.editfrom themes/default/text/`basename {}` ; else {}.editfrom diff -u themes/default/text_custom/`basename {}` ; fi ; fi' \;

