<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    nested_cpf_csv_lists
 */

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

if (!addon_installed('nested_cpf_csv_lists')) {
    return do_template('RED_ALERT', array('_GUID' => 'u31142oyccwcex2ojn8a35yy2k04j98i', 'TEXT' => do_lang_tempcode('MISSING_ADDON', escape_html('nested_cpf_csv_lists'))));
}

require_code('nested_csv');
$csv_structure = get_nested_csv_structure();

// Sanitisation to protect any data not destined to be available in the form
$csv_headings_used = array();
foreach ($csv_structure['cpf_fields'] as $csv_field) {
    $csv_headings_used[$csv_field['csv_heading']] = 1;
    $csv_headings_used[$csv_field['csv_parent_heading']] = 1;
}
foreach ($csv_structure['csv_files'] as $csv_filename => $csv_file) {
    foreach ($csv_file['data'] as $i => $row) {
        foreach (array_keys($row) as $csv_heading) {
            if ($csv_heading == 'deprecated') {
                continue;
            }
            if (!isset($csv_headings_used[$csv_heading])) {
                unset($csv_structure['csv_files'][$csv_filename]['data'][$i][$csv_heading]);
            }
        }
    }
}

// Output JavaScript
?>
(function ($cms, $dom){
    'use strict';

    /** @type {Object} */
    window.nestedCsvStructure = <?= json_encode((array)$csv_structure) ?>;

    $dom.ready.then(function () {
        var forms = document.getElementsByTagName('form');

        for (var i = 0; i < forms.length; i++) {
            injectFormSelectChainingForm(forms[i]);
        }
    });

    function injectFormSelectChainingForm(form) {
        var cpfFields = window.nestedCsvStructure.cpf_fields;
        for (var i in cpfFields) {
            var cpfField = cpfFields[i];
            if (cpfField.possible_fields === undefined) { // Is not part of list
                continue;
            }

            var element = findCpfFieldElement(form, cpfField);
            if (element) {
                injectFormSelectChainingElement(element, cpfField, true);
            }
        }
    }

    function findCpfFieldElement(form, cpfField) {
        for (var i = 0; i < form.elements.length; i++) {

            if (form.elements[i].localName === 'select') {

                for (var j = 0; j < cpfField.possible_fields.length; j++) {

                    if ((form.elements[i].name !== undefined) && (cpfField.possible_fields[j] == form.elements[i].name.replace('[]', ''))) {
                        return form.elements[i];
                    }
                }
            }
        }

        return null;
    }

    function injectFormSelectChainingElement(selectEl, cpfField, initialRun) {
        var cpfFields = window.nestedCsvStructure.cpf_fields;

        var changesMadeAlready = true;

        if (cpfField.csv_parent_heading !== null)  { // We need to look at parent to filter possibilities, if we have one
            var currentValue = $dom.value(selectEl);

            $dom.empty(selectEl);  // Wipe list contents
            var option;

            var parentCpfFieldElement = findCpfFieldElement(selectEl.form, cpfFields[cpfField.csv_parent_heading]);
            var currentParentValue = $dom.value(parentCpfFieldElement);
            if (currentParentValue.length === 0) { // Parent unset, so this is
                option = document.createElement('option');
                selectEl.add(option, null);
                $dom.html(option, <?= json_encode(strval(do_lang('SELECT_OTHER_FIRST', 'xxx'))) ?> +''.replace(/xxx/g, cpfFields[cpfField.csv_parent_heading].label));
                option.value = '';
            } else { // Parent is set, so we need to filter possibilities
                // Work out available (filtered) possibilities
                var csvData = window.nestedCsvStructure.csv_files[cpfField.csv_parent_filename].data;
                var possibilities = [];
                for (var i = 0; i < csvData.length; i++) { // This is going through parent table. Note that the parent table must contain both the child and parent IDs, as essentially it is a linker table. Field names are defined as unique across all CSV files, so you don't need to use the same actual CSV file as the parent field was drawn from.

                    for (var j = 0; j < currentParentValue.length; j++) {

                        if (csvData[i][cpfField.csv_parent_heading] == currentParentValue[j]) {
                            if ((csvData[i]['deprecated'] === undefined) || (csvData[i]['deprecated'] == '0') || (window.handle_csv_deprecation === undefined) || (!window.window.handle_csv_deprecation)) {

                                if (csvData[i][cpfField.csv_heading] === undefined) {
                                    $cms.inform('Configured linker table does not include child field');
                                }
                                possibilities.push(csvData[i][cpfField.csv_heading]);
                            }
                        }
                    }
                }
                if (cpfField.csv_parent_filename != cpfField.csv_filename) {
                    csvData = window.nestedCsvStructure.csv_files[cpfField.csv_filename].data;
                    for (var i = 0; i < csvData.length; i++) {
                        if ((csvData[i]['deprecated'] !== undefined) && (csvData[i]['deprecated'] == '1') && (window.handle_csv_deprecation !== undefined) && (window.window.handle_csv_deprecation)) {
                            for (var j = 0; j < possibilities.length; j++) {
                                if (possibilities[j] == csvData[i][cpfField.csv_heading]) {
                                    possibilities[j] = null; // Deprecated, so remove
                                }
                            }
                        }
                    }
                }
                possibilities.sort();

                // Add possibilities, selecting one if it matches old selection (i.e. continuity maintained)
                if (!selectEl.multiple) {
                    option = document.createElement('option');
                    selectEl.add(option, null);
                    $dom.html(option, <?= json_encode(strval(do_lang('PLEASE_SELECT'))) ?>);
                    option.value = '';
                }
                var previousOne = null;
                for (var i = 0; i < possibilities.length; i++) {
                    if (possibilities[i] === null) {
                        continue;
                    }

                    if (previousOne != possibilities[i]) { // don't allow dupes (which we know are sequential due to sorting)
                        // not a dupe
                        option = document.createElement('option');
                        selectEl.add(option, null);
                        $dom.html(option, escape_html(possibilities[i]));
                        option.value = possibilities[i];
                        if (currentValue.length == 0) {
                            if (selectEl.multiple) { // Pre-select all, if multiple input
                                option.selected = true;
                            }
                        } else {
                            for (var j = 0; j < currentValue.length; j++) {
                                if (possibilities[i] == currentValue[j]) option.selected = true;
                            }
                        }
                        previousOne = possibilities[i];
                    }
                }
                if (!selectEl.multiple) {
                    if (selectEl.options.length == 2) { // Only one thing to select, so may as well auto-select it
                        selectEl.selectedIndex = 1;
                    }
                }
            }

            changesMadeAlready = true;
        } else {
            changesMadeAlready = false;
        }

        if (initialRun) { // This may effectively be called on non-initial runs, but it would be due to the list filter changes causing a selection change that propagates
            var allRefreshFunctions = [];

            $cms.inform('Looking for children of ' + cpfField.csv_heading + '...');

            for (var i in cpfFields) {
                var childCpfField = cpfFields[i], refreshFunction, childCpfFieldElement;

                if (childCpfField.csv_parent_heading == cpfField.csv_heading) {
                    $cms.inform(' ' + cpfField.csv_heading + ' has child ' + childCpfField.csv_heading);

                    childCpfFieldElement = findCpfFieldElement(selectEl.form, childCpfField);

                    refreshFunction = function (childCpfFieldElement, childCpfField) {
                        return function () {
                            $cms.inform('UPDATING: ' + childCpfField.csv_heading);

                            if (childCpfFieldElement) {
                                injectFormSelectChainingElement(childCpfFieldElement, childCpfField, false);
                            }
                        };
                    }(childCpfFieldElement, childCpfField);

                    allRefreshFunctions.push(refreshFunction);
                }
            }

            selectEl.onchange = function () {
                for (var i = 0; i < allRefreshFunctions.length; i++) {
                    allRefreshFunctions[i]();
                }
            };
        } else {
            $dom.trigger(selectEl, 'change');  // Cascade
        }
    }

}(window.$cms || (window.$cms = {}), window.$dom));
