<?php

/*
    Program E
	Copyright 2002, Paul Rydell

	This file is part of Program E.

	Program E is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Program E is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Program E; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/


/**
 * Custom tags
 * 
 * Contains functions that process custom, non-AIML 1.0.x specified tags
 * @author Paul Rydell
 * @copyright 2002
 * @version 0.0.8
 * @license http://opensource.org/licenses/gpl-license.php GNU Public License
 * @package Interpreter
 */


/*

INSTRUCTIONS

If you want to put custom tags into your templates you need to define functions to handle those tags in this file.

Define the function with the name ct_customtagname. Setup the function to be passed the parameters $xmlnode, $inputstar, $thatstar, and $topicstar.

After the function has been defined it will automatically be called to handle XML that matches your custom tag name.

Please review the examples below.

*/


/*
Example:
You want to build email capabilities into the bot and have invented an <email> tag.
Example of how your new email tag will be used:
	<category>
	  <pattern>EMAIL PAUL AND TELL HIM *</pattern>
	  <template>Okay. I emailed him. <email to="paul@rydell.com"><star/></email></template>
	</category>
*/

/*
function ct_email($xmlnode,$inputstar,$thatstar,$topicstar){

	// Capitalize the attributes
	$mynode=upperkeysarray($xmlnode["attributes"]);

	// Get the value of an attribute
	$sendto=$mynode["TO"];

	// Process everything inside the tag
	$emailcontent=recursechildren(realchild($xmlnode),$inputstar,$thatstar,$topicstar);

	// Send an email
	mail($sendto, "E-Mail from Program E", $emailcontent);

	// Don't return anything to the output
	return "";

}
*/

/*
Example:
You want to build math capabilities into the bot and have invented an <add> tag.
Example of how your new add tag will be used:
	<category>
	  <pattern>PLEASE ADD * TO *</pattern>
	  <template>The answer is <add><star index="1"/>,<star index="2"/></add></template>
	</category>
*/

/*
function ct_add($xmlnode,$inputstar,$thatstar,$topicstar){

	$total=0;

	# Process everything inside the tag
	$numberstoadd=recursechildren(realchild($xmlnode),$inputstar,$thatstar,$topicstar);

	# Split the numbers into an array
	$numberstoadd=explode(",",$numberstoadd);

	# Total up the numbers
	foreach($numberstoadd as $x)
		$total += $x;

	# Return the answer
	return $total;

}
*/

?>
