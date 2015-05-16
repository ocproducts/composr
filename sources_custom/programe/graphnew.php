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
 * GraphMaster
 * 
 * Contains the AIML matching functions for Program E
 * @author Paul Rydell
 * @copyright 2002
 * @version 0.0.8
 * @license http://opensource.org/licenses/gpl-license.php GNU Public License
 * @package Interpreter
 * @subpackage MatchEngine
 */

/**
* The debugger function
*
* When uncommented, it will print the messages several functions will call. 
* 
* @todo the entire debug mechanism should be overhauled, this simple one line function doesn't cut it. Perhaps make use of several levels, function names and or timing to spefiy which part to debug.
*
* @param string $msg             The message to be printed in debugger mode
* @param integer $val            no idea what this does, it's used in every function call but not in the function itself
*
* @return void                   Prints to HTML.
*/
function debugger($msg,$val)
{
	#print "$msg\n";
}

/**
* Get the template for the input, that, and topic
*
* Get the template for a paticular pattern and dialogue situation. If the pattern, including topic and that, was found in the cache, the mathcing routine is circumvented and that template used. This saves time. 
*
* @todo The name gettemplate() and {@link findtemplate()} are too similar.
* 
* @uses debugger()
* @uses checkcache()
* @uses graphwalker()
* @uses findtemplate()
* @uses fillcache()
* 
* @global integer                the Bot's ID.
*
* @param string $input           The user's input
* @param string $that            The bot's previous output
* @param string $topic           The contents of the AIML tag <topic>
* @param array &$inputstarvals   contains the contents of the *'s when they are part of the matching pattern input string
* @param array &$thatstarvals    contains the contents of the *'s when they are part of the matching pattern that string
* @param array &$topicstarvals   contains the contents of the *'s when they are part of the matching pattern topic string
* @param array &$patternmatched  contains all patterns that were found. An input can have more than one sentence which are processed seperately.
* @param array &$inputmatched    contains all the individual sentences of a user's input.
*
* @return string                 The template belonging to the matching pattern.
*/
function gettemplate($input,$that,$topic,&$inputstarvals,&$thatstarvals,&$topicstarvals,&$patternmatched,&$inputmatched)
{
	global $selectbot;	

	// Put the input, that, and topic together into a single sentence to find a match for
	$combined = "<input> " . trim($input) . " <that> " . trim($that) . " <topic> " . trim($topic);
	debugger("Combined: $combined",2);

	if (CACHE_CONTROL == 1 && checkcache($combined,$template,$inputstarvals,$thatstarvals,$topicstarvals,$patternmatched,$inputmatched)) {
		debugger("<BR><b>HIT CACHE!</b><br>",2);
		return $template;
	}
	else {

		$inputmatched=array(trim($input)," : ",trim($that)," : ",trim($topic));

		// These arrays will hold the words that matched the wildcards in the pattern
		$inputstarvals=array();
		$thatstarvals=array();
		$topicstarvals=array();

		$patternmatched=array();

		// Get the template with graphwalker function.
		$mytemplateid=graphwalker($combined, -$selectbot , 1, 0, "", $inputstarvals, $thatstarvals, $topicstarvals, $patternmatched);	

		$mytemplate=findtemplate($mytemplateid);

		$s_patternmatched="";
		$s_inputmatched="";

		foreach ($patternmatched as $value) $s_patternmatched .= " " . $value;
		foreach ($inputmatched as $value) $s_inputmatched .= $value;

		$patternmatched = $s_patternmatched;
		$inputmatched = $s_inputmatched;

		if (CACHE_CONTROL == 1) {
			fillcache($combined, $mytemplateid, $inputstarvals, $thatstarvals, $topicstarvals, $patternmatched, $inputmatched);
		}

		return $mytemplate;

	}
}

/**
* The graphwalker function finds the pattern that matches the combined input of input, that, and topic. 
*
* Then it returns the template that matches. It is recursive.
*
* @uses debugger()
* @uses dographquery()
* @uses fastforward()
* @uses addtostar()
* @uses graphwalker()
*
* @param string $input           The user's input
* @param string $parent          The word's parent ID
* @param string $timesthrough    Number of recursions????
* @param boolean $onwild         whether or not a wildcard is processed (Anne: I think)
* @param string $parton          Can be input, that, topic. 
* @param array &$inputstarvals   contents of the *'s when they are part of the matching pattern input string
* @param array &$thatstarvals    contents of the *'s when they are part of the matching pattern that string
* @param array &$topicstarvals   contents of the *'s when they are part of the matching pattern topic string
* @param array &$patternmatched  contains all patterns that were found. A user's input can have more than one sentence.
*
* @return integer                the Template ID to be returned.                 
*/
function graphwalker($input,$parent,$timesthrough,$onwild,$parton,&$inputstarvals,&$thatstarvals,&$topicstarvals,&$patternmatched){

	$curpmsize=0;

	//print "input: $input<BR>";
	debugger("Graphwalker called. Input|$input| Parent: $parent Timesthrough: $timesthrough Onwild: $onwild Parton: $parton",1);

	$continuenode=1;

	$oinputstarvals=$inputstarvals;
	$othatstarvals=$thatstarvals;
	$otopicstarvals=$topicstarvals;

	$input=trim($input);

	// If there is not a space in the input then use the whole input. Else get the first word from the input and put the rest of the input into $remains variable.
	if (strpos($input," ")===false){
		$word=$input;
		$remains="";
	}
	else {
		$word=substr($input,0,strpos($input," "));
		$remains=substr($input,strpos($input," "));
	}

	debugger("Word|$word|",1);
	debugger("Remains|$remains|",1);

	// Figure out which part we are on: input, that, or topic.
	if ($word=="<input>"){
		$parton="input";
	}
	elseif ($word=="<that>"){
		$parton="that";
		$patternmatched[]=":";
	}
	elseif ($word=="<topic>"){
		$parton="topic";
		$patternmatched[]=":";
	}

	// See if the word we are on comes next in the graph we are walking or if a wildcard exists.
	//$query="select id,ordera,isend from patterns where (word='" . addslashes($word) . "' or word is null) and parent=$parent";
	//dographquery($query,$whichresult);

	dographquery($whichresult, $word, $parent);

	// Look for _ wildcard first because it is first "alphabetically"
	if (($whichresult[0]!=-1)&&($word!="<input>")&&($word!="<that>")&&($word!="<topic>")){

		// Don't keep looking in this portion of the graph - don't check for atomic or * because we matched already.
		$continuenode=-1;

		debugger("processing an '_' here",2);

		$patternmatched[]="_";
		$curpmsize=sizeof($patternmatched);

		// If it is the last word in its context
		if ($whichresult[3]==1) {

			// The word we were on matched a wildcard so add the word to the star array.
			// Also it is the last word in this context so add everything up to the next context to the star.
			$ffremains=$remains;
			$newword=fastforward($word,$ffremains);
			addtostar($parton,$newword,$inputstarvals,$thatstarvals,$topicstarvals,1);

			// Now we take off the first word and everything up to the next context because it matched and call the graphwalker
			$retvalue = graphwalker($ffremains,$whichresult[0],1,1,$parton,$inputstarvals,$thatstarvals,$topicstarvals,$patternmatched);
		}
		else {

			// The word we were on matched a wildcard so add the word to the star array.s
			addtostar($parton,$word,$inputstarvals,$thatstarvals,$topicstarvals,1);

			// Now we take off the first word because it matched and call the graphwalker
			$retvalue = graphwalker($remains,$whichresult[0],1,1,$parton,$inputstarvals,$thatstarvals,$topicstarvals,$patternmatched);
		}

		// If the graphwalker returns blank then it never found a match. If it got a match we return it.
		if ($retvalue!=""){
			debugger("Retvalue from graphwalker not blank. Returning it",2);
			return $retvalue;
		}
		// If it didn't match then we continue on down the current node but next check for an atomic match.
		else {
			debugger("Returning a new call to graphwalker1. Input: $input Parent: $parent",2);

			// Revert back to our original starvals
			$inputstarvals=$oinputstarvals;
			$thatstarvals=$othatstarvals;
			$topicstarvals=$otopicstarvals;

			$curpdiff=sizeof($patternmatched) - $curpmsize;

			for ($curpc=0;$curpc<=$curpdiff;$curpc++){
				array_pop($patternmatched);
			}

			// Ensure that we continue looking for a match.
			$continuenode=1;
		}

	}

	// Look for an atomic match. Atomic match is where the whole word matches identically.
	if (($whichresult[1]!=-1)&&($continuenode==1)){

		$continuenode=-1;

		// If we found a result and our word was "" then we have reached the end of the pattern so we return the template associated.
		if ($word==""){
			debugger("Result not blank and word is. Returning the found temlate",2);
			#return findtemplate($whichresult[1]);
			return $whichresult[1];
		}
		// If it is not the end of the pattern we keep going
		else {

			if (($word!="<input>")&&($word!="<that>")&&($word!="<topic>")){

				$patternmatched[]=$word;
				$curpmsize=sizeof($patternmatched);
			}

			debugger("Result not blank and word is not blank. Calling graphwalker.",2);

			// We take off the first word and call the graphwalker again.
			$retvalue = graphwalker($remains,$whichresult[1],1,0,$parton,$inputstarvals,$thatstarvals,$topicstarvals,$patternmatched);

			// If we got a match we return it
			if ($retvalue!=""){
				debugger("Retvalue from graphwalker not blank. Returning it",2);					
				return $retvalue;
			}
			// Else we continue down our current node alphabetically to *
			else {

				$curpdiff=sizeof($patternmatched) - $curpmsize;

				for ($curpc=0;$curpc<=$curpdiff;$curpc++){
					array_pop($patternmatched);
				}

				$continuenode=1;

			}
		}
	}

	// Will this if statement make things much faster???
	//if (($word=="<input>")||($word=="<that>")||($word=="<topic>")){
	//	debugger("WORD MATCHED INPUT THAT OR TOPIC - RETURNING BLANK");
	//	return "";
	//}



	// Look for *
	if (($whichresult[2]!=-1)&&($continuenode==1)&&($word!="<input>")&&($word!="<that>")&&($word!="<topic>")){

		debugger("Looking for a '*' here",2);		
		debugger("Result not blank and word is not blank. Calling graphwalker.",2);

		$patternmatched[]="*";
		$curpmsize=sizeof($patternmatched);

		// If it is the last word in its context
		if ($whichresult[5]==1) {

			$ffremains=$remains;
			$newword=fastforward($word,$ffremains);			

			addtostar($parton,$newword,$inputstarvals,$thatstarvals,$topicstarvals,1);

			// Call graphwalker with the first word removed from input
			$retvalue = graphwalker($ffremains,$whichresult[2],1,1,$parton,$inputstarvals,$thatstarvals,$topicstarvals,$patternmatched);
		}
		else {

			addtostar($parton,$word,$inputstarvals,$thatstarvals,$topicstarvals,1);

			// Call graphwalker with the first word removed from input
			$retvalue = graphwalker($remains,$whichresult[2],1,1,$parton,$inputstarvals,$thatstarvals,$topicstarvals,$patternmatched);
		}


		// If found result then return it up.
		if ($retvalue!=""){
			debugger("Retvalue from graphwalker not blank. Returning it",2);
			return $retvalue;
		}
		else {

			$curpdiff=sizeof($patternmatched) - $curpmsize;

			for ($curpc=0;$curpc<=$curpdiff;$curpc++){
				array_pop($patternmatched);
			}
		}

	}

	// Else no match found...
	if ((($whichresult[0]==-1)&&($whichresult[1]==-1)&&($whichresult[2]==-1))||($continuenode==1)) {			
		//If we were most recently on a wildcard (*,_) then we are still matching it.
		if (($onwild==1)&&($word!="")&&($word!="<that>")&&($word!="<topic>")){
			debugger("On wild and in *. keep going with graphwalker.",2);

			addtostar($parton,$word,$inputstarvals,$thatstarvals,$topicstarvals,2);				

			return graphwalker($remains,$parent,1,1,$parton,$inputstarvals,$thatstarvals,$topicstarvals,$patternmatched);
		}
		else {
			//We didn't find anything. We need to come back out
			debugger("Result is blank from query in *. Returning blank",2);	
			return "";
		}

	}

}

/**
* Does a database query for {@link graphwalker()}
*
* Retrieves the ID, ordera, isend of the word to be searched
* $query="select id,ordera,isend from patterns where word='" . addslashes($word) . "' or word is null and parent=$parent";
*
* @todo The array returned is also returned via call-by-reference. Investigate which should be chosen.
*
* @uses debugger()
*
* @global integer                   The number of queries that have been executed
*
* @param string $query              The SQL code to be executed
* @param array &$whichresult        contains ID, ordera and isend from the query. note: call-by-reference
*
* @return array                     contains ID, ordera and isend from the query. note: call-by-reference array exists too.
*/
function dographquery(&$whichresult, $word, $parent){

	$query="select id,ordera,isend from patterns where (word='" . addslashes($word) . "' or word is null) and parent=$parent";

	global $numselects;

	$numselects++;
	debugger("dographquery: $query\n",2);

	$whichresult[]=-1;
	$whichresult[]=-1;
	$whichresult[]=-1;

	$whichresult[]=-1;
	$whichresult[]=-1;
	$whichresult[]=-1;

	$selectcode = mysql_query($query);
	if ($selectcode){
		if(!mysql_numrows($selectcode)){
			return $whichresult;
		}
		else{
			while ($q = mysql_fetch_array($selectcode)){
				if ($q[1]==1){
					$whichresult[0]=$q[0];

					// If it is the last word in its context.
					if ($q[2]==1){
						$whichresult[3]=1;
					}

				}
				elseif ($q[1]==2){
					$whichresult[1]=$q[0];

					// If it is the last word in its context.
					if ($q[2]==1){
						$whichresult[4]=1;
					}

				}
				elseif ($q[1]==3){
					$whichresult[2]=$q[0];

					// If it is the last word in its context.
					if ($q[2]==1){
						$whichresult[5]=1;
					}

				}



			}
			return $whichresult;
		}
	}

}



/**
* Retrieve the template from the templates table
*
* Get the template from the templates table. and return it.
* 
* @todo The name {@link gettemplate()} and findtemplate() are too similar.
*
* @param integer $id                  The ID of the template to be returned
*
* @return string                      The contents of <template/> for this category.
*/
function findtemplate($id){

	$query = "select template from templates where id=$id";
	debugger($query,2);
	$selectcode = mysql_query($query);
	if ($selectcode){
		if(!mysql_numrows($selectcode)){
			return "";
		}
		else{
			while ($q = mysql_fetch_array($selectcode)){
				return $q[0];
			}
		}
	}

	return "";
}


/**
* Deals with creating and adding to the star arrays
*
* If a * or _ is part of the matched pattern, what is covered by that variable is then stored in the 'star arrays'. This function creates and adds words to that array or array element.
*
* @param string $parton          Can be input, that, topic. 
* @param string $word            The word that needs to be stored
* @param array &$inputstarvals   contents of the *'s when they are part of the matching pattern input string
* @param array &$thatstarvals    contents of the *'s when they are part of the matching pattern that string
* @param array &$topicstarvals   contents of the *'s when they are part of the matching pattern topic string
* @param integer $action         what action needs to be done, append to existing or create new.
*
* @return void                   info is returned via call-by-reference variables.
*/
function addtostar($parton,$word,&$inputstarvals,&$thatstarvals,&$topicstarvals,$action){

	if (($word!="<nothing>")&&($word!="<that>")&&($word!="<topic>")){

		if ($parton=="input"){

			// Action 1 is adding a new star
			if ($action==1){
				$inputstarvals[]=$word;
			}
			// Action 2 is appending to existing star
			elseif ($action==2){
				$inputstarvals[sizeof($inputstarvals)-1].= " " . $word;
			}

		}
		elseif ($parton=="that"){

			if ($action==1){
				$thatstarvals[]=$word;
			}
			elseif ($action==2){
				$thatstarvals[sizeof($thatstarvals)-1].= " " . $word;
			}

		}
		elseif ($parton=="topic"){

			if ($action==1){
				$topicstarvals[]=$word;
			}
			elseif ($action==2){
				$topicstarvals[sizeof($topicstarvals)-1].= " " . $word;
			}

		}

	}
}


/**
* Fast forward to the processing of the next context
*
* Remainder of the user's input covered by a *. So so add everything up to the next context (<that> & <topic>) to the star.
*
* @todo $newremains is a variable that is created, and filled but not returned. It is perhaps old code that 
*       pre dates {@link addtostar()} that saves the returned value in {@link graphmaster()}. 
* 
*
* @param string $word                     Current processed word
* @param string $ffremains                Words that remain to be processed.
*
* @return string                          words to be saved by {@link addtostar()}
*/
function fastforward($word,$ffremains){

	$starwords=$word;

	$newremains="";

	$ffremains=trim($ffremains);
	$ffar=explode(" ",$ffremains);

	$x=0;
	$currentword=$ffar[$x];

	while (($currentword!="<that>")&&($currentword!="<topic>")&&($currentword!="")){

		$starwords = $starwords . " " . $currentword;
		$x++;

		if ($x>=sizeof($ffar)){
			break;
		} else {
			$currentword=$ffar[$x];
		}

	}

	for ($y=$x;$y<sizeof($ffar);$y++){
		$newremains =  $newremains . " " . $ffar[$y];
	}

	$ffremains=trim($newremains);

	return $starwords;

}


/**
* Check to see if exact input-that-topic exists in cache
*
* GmCache is a log that contains all unique entries. If the exact same input-that-topic is requested that is found in GmCache, then it's template reference is used instead of traversing the binary AIML tree. Saving response time.
*
* @param string $combined                  the complete input in <input>word word<that>word word<topic>word word format. 
* @param array &$inputstarvals   contents of the *'s when they are part of the matching pattern input string
* @param array &$thatstarvals    contents of the *'s when they are part of the matching pattern that string
* @param array &$topicstarvals   contents of the *'s when they are part of the matching pattern topic string
* @param array &$patternmatched  all the patterns that match input, i.e. multiple sentences are kept seperate.
* @param array &$inputmatched    all the matched input.
*
* @return boolean                true/false Note, info is also transfere through the call-by-reference variables.
*/

function checkcache($combined,&$template,&$inputstarvals,&$thatstarvals,&$topicstarvals,&$patternmatched,&$inputmatched)
{
	$ccquery="select template,inputstarvals,thatstarvals,topicstarvals,patternmatched,inputmatched from gmcache where combined='" . addslashes($combined) . "' and " . whichbots();	

	$selectcode = mysql_query($ccquery);
	if ($selectcode){
		if(!mysql_numrows($selectcode)){
			return false;
		}
		else{
			while ($q = mysql_fetch_array($selectcode)){

				$template=findtemplate($q[0]);
				$inputstarvals=explode(",",$q[1]);
				$thatstarvals=explode(",",$q[2]);
				$topicstarvals=explode(",",$q[3]);
				$patternmatched=$q[4];
				$inputmatched=$q[5];

				return true;
			}
		}
	}

	return false;

}


/**
* Add an entry in the GMcache table
*
* @global integer                  The selected bot.
*
* @param string $combined                  the complete input in <input>word word<that>word word<topic>word word format. 
* @param string $mytemplate                the reply to the input
* @param string $inputstarvals             contents of the input star
* @param string $thatstarvals              contents of the that star
* @param string $topicstarvals             contents of the topic star
* @param string $patternmatched            the AIML category pattern that matches the input
* @param string $inputmatched              the input that matched the category.
*
* @return void
*/
function fillcache($combined,$mytemplate,$inputstarvals,$thatstarvals,$topicstarvals,$patternmatched,$inputmatched)
{
	global $selectbot;	

	$ccquery="insert into gmcache (bot, combined,template,inputstarvals,thatstarvals,topicstarvals,patternmatched,inputmatched) values ($selectbot,'" . addslashes($combined) . "'," . $mytemplate . ",'" . addslashes(arraytostring($inputstarvals)) . "','" . addslashes(arraytostring($thatstarvals)) . "','" . addslashes(arraytostring($topicstarvals)) . "','" . addslashes($patternmatched) . "','" . addslashes($inputmatched) . "')";

	$selectcode = mysql_query($ccquery);
	if ($selectcode){
	}

}


/**
* Turn an array into a string
*
* take each element of the array and put all of them into one big string; one after the other.
*
* @param array $myarray
* 
* @return string                         the contents of the array into a string.
*/
function arraytostring($myarray)
{
	$retstring="";

	for ($x=0;$x<sizeof($myarray);$x++){
		$retstring .= $myarray[$x] . ",";	
	}

	$retstring=substr($retstring,0,strlen($retstring)-1);

	return $retstring;

}

