<?php
// ----------------------------------------------------------------------------
// This file is part of PHP Crossword.
//
// PHP Crossword is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
// 
// PHP Crossword is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with Foobar; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
// ----------------------------------------------------------------------------

/**
 * PHP Crossword Generator
 *
 * @package		PHP_Crossword 
 * @copyright	Laurynas Butkus, 2004
 * @license		http://opensource.org/licenses/gpl-license.php GNU Public License
 * @version		0.2
 */

define("_PC_DIR", dirname(__FILE__) . "/");

require_code('php-crossword/php_crossword_grid.class');
require_code('php-crossword/php_crossword_cell.class');
require_code('php-crossword/php_crossword_word.class');

define("PC_AXIS_H", 1);
define("PC_AXIS_V", 2);
define("PC_AXIS_BOTH", 3);
define("PC_AXIS_NONE", 4);
define("PC_WORDS_FULLY_CROSSED", 10);

class PHP_Crossword 
{
	var $rows = 15;
	var $cols = 15;
	var $grid;

	var $max_full_tries = 10;
	var $max_words = 15;
	var $max_tries = 50;

	var $_match_line;
	var $_full_tries = 0;
	var $_tries = 0;
	var $_debug = FALSE;
	var $_items;

	var $word_pool = NULL;

	/**
	 * Constructor
	 * @param int $rows 
	 * @param int $cols
	 */
	function __construct($rows = 15, $cols = 15)
	{
		$this->rows = (int)$rows;
		$this->cols = (int)$cols;
	}

	/**
	 * Enable / disable debugging
	 * @param boolean $debug
	 */
	function setDebug($debug = TRUE)
	{
		$this->_debug = (boolean)$debug;
	}

	/**
	 * Set number of words the crossword shoud have
	 * @param int $max_words
	 */
	function setMaxWords($max_words)
	{
		$this->max_words = (int)$max_words;
	}

	/**
	 * Set maximum number of tries to generate full crossword
	 * @param int $max_full_tries
	 */
	function setMaxFullTries($max_full_tries)
	{
		$this->max_full_tries = (int)$max_full_tries;
	}

	/**
	 * Set max tries to pick the words
	 * @param int $max_tries
	 */
	 function setMaxTries($max_tries)
	{
		$this->max_tries = (int)$max_tries;
	}

	/**
	 * Generate crossword
	 * @return boolean TRUE - if succeeded, FALSE - if unable to get required number of words
	 */
	function generate()
	{
		// set the number of full tries
		$this->_full_tries = 0;

		// try to generate until we get required number of words
		while ($this->_full_tries < $this->max_full_tries)
		{
			// reset grid
			$this->reset();

			// count number of tried to generate crossword 
			// with required number of words
			$this->_full_tries++;

			// pick and place first word
			$this->__placeFirstWord();

			// try to find other words and place them
			$this->__autoGenerate();

			//dump($this->grid->countWords());

			// if we have enough words - 
			if ($this->grid->countWords() == $this->max_words)
			{
				$this->_items = $this->__getItems();
				return TRUE;
			}
		}

		if ($this->_debug)
			echo "ERROR: unable to generate {$this->max_words} words crossword (tried {$this->_full_tries} times)";

		return FALSE;
	}

	/**
	 * Reset grid
	 */
	function reset()
	{
		// create new grid object
		$this->grid = new PHP_Crossword_Grid($this->rows, $this->cols);

		// reset number of tries to pick words
		$this->_tries = 0;

		// reset crossword items
		$this->_items = NULL;
	}

	/**
	 * Get crossword HTML (useful for generator debugging)
	 * @param array params
	 * @return string HTML
	 */
	function getHTML($params = array())
	{
		return $this->grid->getHTML($params);
	}

	/**
	 * Get crossword items
	 * @return array
	 */
	function getWords()
	{
		return $this->_items;
	}

	/**
	 * Get crossword items array
	 * @private
	 * @return array  
	 */
	function __getItems()
	{
		$items = array();

		for ($i = 0; $i < count($this->grid->words); $i++)
		{
			$w =& $this->grid->words[$i];

			$items[] = array(
				"word"		=> $w->word,
				"question"	=> $this->getQuestion($w->word),
				"x"			=> $w->getStartX() + 1,
				"y"			=> $w->getStartY() + 1,
				"axis"		=> $w->axis,
				);
		}

		return $items;
	}

	/**
	 * Get question for the word
	 * @param string $word
	 * @return string $question
	 */
	function getQuestion($word)
	{
		return $word;
	}

	/**
	 * Try to generate crossword automatically 
	 * (until we get enough word or reach number of maximum tries
	 * @private
	 */
	function __autoGenerate()
	{
		while ($this->grid->countWords() < $this->max_words && $this->_tries < $this->max_tries)
		{
			$this->_tries++;

			// dump( "Words: " . $this->grid->countWords() . ", Tries: $this->_tries" );

			$w =& $this->grid->getRandomWord();

			if ($w == PC_WORDS_FULLY_CROSSED)
			{
				// echo "NOTE: All words fully crossed...";
				break;
			}

			$axis = $w->getCrossAxis();
			$cells =& $w->getCrossableCells();

			// dump( "TRYING WORD: ".$w->word );

			while (count($cells))
			{
				$n = array_rand($cells);
				$cell =& $cells[$n];

				//dump( "TRYING CELL: [$cell->x/$cell->y]:". $cell->letter );
				//dump( "COUNT CELLS: ". count($cells) );

				$list =& $this->__getWordWithStart($cell, $axis);
				$word = $list[0];
				$start =& $list[1];

				if ($start)
				{
					$this->grid->placeWord($word, $start->x, $start->y, $axis);
					break;
				}

				//dump( "CAN'T FIND CROSSING FOR: ".$cells[$n]->letter );
				$cells[$n]->setCanCross($axis, FALSE);
				unset($cells[$n]);
			}
		}
	}

	/**
	 * Try to pick the word crossing the cell
	 * @private
	 * @param object $cell Cell object to cross
	 * @param int $axis 
	 * @return array Array of 2 items - word and start cell object
	 */
	function __getWordWithStart(&$cell, $axis)
	{
		$start = & $this->grid->getStartCell($cell, $axis);
		$end = & $this->grid->getEndCell($cell, $axis);

		$word = $this->__getWord($cell, $start, $end, $axis);

		if (!$word) return NULL;

		$pos = NULL;

		do
		{
			// dump( $this->_match_line );
			$s_cell = & $this->__calcStartCell($cell, $start, $end, $axis, $word, $pos);
			$can = $this->grid->canPlaceWord($word, $s_cell->x, $s_cell->y, $axis);

			//if ( !$can )
			// dump(strtoupper("Wrong start position [{$s_cell->x}x{$s_cell->y}]! Relocating..."));

		}
		while (!$can);

		return array($word, &$s_cell);
	}

	/**
	 * Calculate starting cell for the word
	 * @private
	 * @param object $cell crossing cell
	 * @param object $start minimum starting cell
	 * @param object $end maximum ending cell
	 * @param int $axis
	 * @param string $word
	 * @param int $pos last position
	 * return object|FALSE starting cell object or FALSE ir can't find
	 */
	function &__calcStartCell(&$cell, &$start, &$end, $axis, $word, &$pos)
	{
		$x = $cell->x;
		$y = $cell->y;

		if ($axis == PC_AXIS_H)
		{
			$t =& $x;
			$s = $cell->x - $start->x;
			$e = $end->x - $cell->x;
		}
		else
		{
			$t =& $y;
			$s = $cell->y - $start->y;
			$e = $end->y - $cell->y;
		}

		$l = strlen($word);

		do
		{
			$offset = isset($pos) ? $pos+1 : 0;
			$pos = strpos($word, $cell->letter, $offset);
			$a = $l-$pos-1;
			if ($pos <= $s && $a <= $e)
			{
				$t-= $pos;
				return $this->grid->cells[$x][$y];
			}
		}
		while ($pos !== FALSE);

		return FALSE;
	}

	/**
	 * Try to get the word
	 * @private
	 * @param object $cell crossing cell
	 * @param object $start minimum starting cell
	 * @param object $end maximum ending cell
	 * @param int $axis
	 * @return string word
	 */
	function __getWord(&$cell, &$start, &$end, $axis)
	{
		$this->_match_line = $this->__getMatchLine($cell, $start, $end, $axis);
		$regexp = $this->__getMatchRegexp($this->_match_line);
		$min = $this->__getMatchMin($this->_match_line);
		$max = strlen($this->_match_line);

		$rs = $this->__loadWords($regexp, $min, $max);

		return $this->__pickWord($rs, $regexp);
	}

	/**
	 * Pick the word from the resultset
	 * @private
	 * @param array $rs
	 * @param string $regexp Regexp to match	 
	 * return string|NULL word or NULL if couldn't find
	 */
	function __pickWord(&$rs, $regexp)
	{
		shuffle($rs);
		foreach ($rs as $word)
		{
			if (preg_match("/{$regexp}/", $word))
			{
				return $word;
			}
		}

		return NULL;
	}

	/**
	 * Generate word matching line
	 * @private
	 * @param object $cell crossing cell
	 * @param object $start minimum starting cell
	 * @param object $end maximum ending cell
	 * @param int $axis
	 * @return string matching line
	 */
	function __getMatchLine(&$cell, &$start, &$end, $axis)
	{
		$x = $start->x;
		$y = $start->y;

		if ($axis == PC_AXIS_H)
		{
			$n =& $x;
			$max = $end->x;
		}
		else
		{
			$n =& $y;
			$max = $end->y;
		}

		$str = '';

		while ($n <= $max)
		{
			$cell =& $this->grid->cells[$x][$y];
			$str.= isset($cell->letter) ? $cell->letter : '_';
			$n++;
		}

		return $str;
	}

	/**
	 * Get minimum match string	 
	 * @private
	 * @param string $str match string
	 * @return string
	 */
	function __getMatchMin($str)
	{
		$str = preg_replace("/^_+/", "", $str, 1);
		$str = preg_replace("/_+$/", "", $str, 1);
		return strlen($str);
	}

	function __callback1($matches)
	{
		return '^.{0,'.strlen('\\0').'}';
	}

	function __callback2($matches)
	{
		return '.{0,'.strlen('\\0').'}$';
	}

	function __callback3($matches)
	{
		return '.{'.strlen('\\0').'}';
	}

	/**
	 * Get REGEXP for the match string
	 * @private
	 * @param string $str match string
	 * @return string
	 */
	function __getMatchRegexp($str)
	{
		$str = preg_replace_callback('#^_*#', array($this, '__callback1'), $str, 1);
		$str = preg_replace_callback('#_*$#', array($this, '__callback2'), $str, 1);
		$str = preg_replace_callback('#_+#', array($this, '__callback3'), $str);
		return $str;
	}

	/**
	 * Place first word to the cell
	 * @private
	 */
	function __placeFirstWord()
	{
		$word = $this->__getRandomWord($this->grid->getCols());

		$x = $this->grid->getCenterPos(PC_AXIS_H, $word);
		$y = $this->grid->getCenterPos(PC_AXIS_V);

		$this->grid->placeWord($word, $x, $y, PC_AXIS_H);
	}

	/**
	 * Load words from Composr
	 */
	function __initialiseWords()
	{
		if (is_null($this->word_pool))
		{
			$this->word_pool=array();

			// From posters
			$all_members=$GLOBALS['FORUM_DRIVER']->get_top_posters(100);
			foreach ($all_members as $member)
			{
				$this->word_pool[]=$GLOBALS['FORUM_DRIVER']->mrow_username($member);
			}

			// From keywords
			$meta=$GLOBALS['SITE_DB']->query_select('seo_meta_keywords',array('meta_keyword'));
			foreach ($meta as $m)
			{
				$trans=get_translated_text($m['meta_keyword']);
                $this->word_pool[$trans]=true;
			}

            $this->word_pool=array_keys($this->word_pool);
		}
	}

	/**
	 * Load words for the match
	 * @private
	 * @param string $match regular expression match
	 * @param int $len_min minimum length of the word
	 * @param int $len_max maximum length of the word
	 * @return result SQL result
	 */
	function __loadWords($match, $len_min, $len_max)
	{
		$this->__initialiseWords();

		$possible=array();
		foreach ($this->word_pool as $w)
		{
			if ((strlen($w)>=$len_min) && (strlen($w)<=$len_max) && (preg_match('#'.$match.'#',$w)!=0))
				$possible[]=$w;
		}

		return $possible;
	}

	/**
	 * Get random word
	 * @private
	 * @param int $max_length maximum word length
	 * @return string word
	 */
	function __getRandomWord($max_length)
	{
		$this->__initialiseWords();
		$word_pool=$this->word_pool;
		shuffle($word_pool);
		foreach ($word_pool as $w)
		{
			if (strlen($w)<=$max_length)
				return $w;
		}

		return NULL;
	}

	/**
	 * Check if the word already exists in the database
	 * @param string $word
	 * @return boolean
	 */
	function existsWord($word)
	{
		$this->__initialiseWords();
		return in_array($word,$this->word_pool);
	}

	/**
	 * Insert word into database
	 * @param string $word
	 * @param string $question (ignored - we make questions by shuffling the characters)
	 */
	function insertWord($word, $question)
	{
		$word = trim($word);
		$word = preg_replace("/[\_\'\"\%\*\+\\\\\/\[\]\(\)\.\{\}\$\^\,\<\>\;\:\=\?\#\-]/", '', $word);
		if (empty($word)) return FALSE;
		if ($this->existsWord($word)) return FALSE;

		$this->__initialiseWords();
		$this->word_pool[]=$word;
	}

	/**
	 * Get generated crossword XML
	 * @return string XML
	 */
	function getXML()
	{
		$words = $this->getWords();

		if (!count($words))
			return "<error>There are no words in the grid.</error>";

		$xml = array();
		$xml[] = "<crossword>";

		$xml[] = "	<grid>";
		$xml[] = "		<cols>{$this->cols}</cols>";
		$xml[] = "		<rows>{$this->rows}</rows>";
		$xml[] = "		<words>" . count($words) . "</words>";
		$xml[] = "	</grid>";

		$xml[] = "	<items>";

		foreach ((array)$words as $item)
			$xml[] = $this->__wordItem2XML($item, "\t\t");

		$xml[] = "	</items>";

		if ($this->_debug)
			$xml[] = "	<html>" . htmlspecialchars($this->grid->getHTML()) . "</html>";

		$xml[] = "</crossword>";

		$xml = implode("\n", $xml);

		return $xml;
	}

	/**
	 * Get XML of the word item
	 * @private
	 * @param object $item word item
	 * @param string $ident
	 * @return string XML
	 */
	function __wordItem2XML($item, $ident)
	{
		$xml = array();
		$xml[] = $ident . "<item>";

		foreach ((array)$item as $key=>$val)
		{
			$key = htmlspecialchars($key);
			$val = htmlspecialchars($val);
			$xml[] = "	<{$key}>{$val}</{$key}>";
		}

		$xml[] = "</item>";

		$xml = implode("\n{$ident}", $xml);

		return $xml;
	}

	/**
	 * Get number of words
	 * @return int
	 */
	function countWords()
	{
		$this->__initialiseWords();
		return count($this->word_pool);
	}

	/**
	 * Generate crossword from provided words list
	 * @param string $words_list
	 * @return boolean TRUE on success
	 */
	function generateFromWords($words_list)
	{
		// save current settings
		$_max_words = $this->max_words;

		// split words list and  insert
		foreach (explode("\n", $words_list) as $line)
			foreach (explode(" ", $line) as $word)
				$this->insertWord($word, '');

		// try to generate crossword from all passed words
		$required_words = $this->countWords();

		// if user entered more words then max_words - require max_words...
		if ($required_words > $_max_words)
			$required_words = $_max_words;

		$success = FALSE;

		while ($required_words > 1)
		{
			$this->setMaxWords($required_words);

			if ($success = $this->generate()) 
				break;

			$required_words--;
		}

		// restore previous settings
		$this->setMaxWords($_max_words);

		return $success;
	}

}
?>
