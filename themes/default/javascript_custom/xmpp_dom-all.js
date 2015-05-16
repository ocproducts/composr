/*{$,Parser hint: .innerHTML okay}*/
/*{$,Parser hint: pure}*/

// =========================================================================
//
// xmlsax.js - an XML SAX parser in JavaScript.
//
// version 3.1
//
// =========================================================================
//
// Copyright (C) 2001 - 2002 David Joham (djoham@yahoo.com) and Scott Severtson
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.

// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
// Lesser General Public License for more details.

// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA	02111-1307	USA
//
//
// Visit the XML for <SCRIPT> home page at http://xmljs.sourceforge.net
//

// CONSTANTS

// =========================================================================
// =========================================================================
// =========================================================================
var whitespace = "\n\r\t ";


/***************************************************************************************************************
XMLP is a pull-based parser. The calling application passes in a XML string
to the constructor, then repeatedly calls .next() to parse the next segment.
.next() returns a flag indicating what type of segment was found, and stores
data temporarily in couple member variables (name, content, array of
attributes), which can be accessed by several .get____() methods.

Basically, XMLP is the lowest common denominator parser - an very simple
API which other wrappers can be built against.
*****************************************************************************************************************/


XMLP = function(strXML) {
	/*******************************************************************************************************************
	function:	 this is the constructor to the XMLP Object

	Author:	 Scott Severtson

	Description:
		Instantiates and initializes the object
	*********************************************************************************************************************/
	// Normalize line breaks
	strXML = SAXStrings.replace(strXML, null, null, "\r\n", "\n");
	strXML = SAXStrings.replace(strXML, null, null, "\r", "\n");

	this.m_xml = strXML;
	this.m_iP = 0;
	this.m_iState = XMLP._STATE_PROLOG;
	this.m_stack = new Stack();
	this._clearAttributes();

}	// end XMLP constructor


// CONSTANTS	(these must be below the constructor)

// =========================================================================
// =========================================================================
// =========================================================================

XMLP._NONE	= 0;
XMLP._ELM_B	 = 1;
XMLP._ELM_E	 = 2;
XMLP._ELM_EMP = 3;
XMLP._ATT	 = 4;
XMLP._TEXT	= 5;
XMLP._ENTITY	= 6;
XMLP._PI		= 7;
XMLP._CDATA	 = 8;
XMLP._COMMENT = 9;
XMLP._DTD	 = 10;
XMLP._ERROR	 = 11;

XMLP._CONT_XML = 0;
XMLP._CONT_ALT = 1;

XMLP._ATT_NAME = 0;
XMLP._ATT_VAL	= 1;

XMLP._STATE_PROLOG = 1;
XMLP._STATE_DOCUMENT = 2;
XMLP._STATE_MISC = 3;

XMLP._errs = new Array();
XMLP._errs[XMLP.ERR_CLOSE_PI		 = 0 ] = "PI: missing closing sequence";
XMLP._errs[XMLP.ERR_CLOSE_DTD		= 1 ] = "DTD: missing closing sequence";
XMLP._errs[XMLP.ERR_CLOSE_COMMENT	= 2 ] = "Comment: missing closing sequence";
XMLP._errs[XMLP.ERR_CLOSE_CDATA	= 3 ] = "CDATA: missing closing sequence";
XMLP._errs[XMLP.ERR_CLOSE_ELM		= 4 ] = "Element: missing closing sequence";
XMLP._errs[XMLP.ERR_CLOSE_ENTITY	 = 5 ] = "Entity: missing closing sequence";
XMLP._errs[XMLP.ERR_PI_TARGET		= 6 ] = "PI: target is required";
XMLP._errs[XMLP.ERR_ELM_EMPTY		= 7 ] = "Element: cannot be both empty and closing";
XMLP._errs[XMLP.ERR_ELM_NAME		 = 8 ] = "Element: name must immediatly follow \"<\"";
XMLP._errs[XMLP.ERR_ELM_LT_NAME	= 9 ] = "Element: \"<\" not allowed in element names";
XMLP._errs[XMLP.ERR_ATT_VALUES	 = 10] = "Attribute: values are required and must be in quotes";
XMLP._errs[XMLP.ERR_ATT_LT_NAME	= 11] = "Element: \"<\" not allowed in attribute names";
XMLP._errs[XMLP.ERR_ATT_LT_VALUE	 = 12] = "Attribute: \"<\" not allowed in attribute values";
XMLP._errs[XMLP.ERR_ATT_DUP		= 13] = "Attribute: duplicate attributes not allowed";
XMLP._errs[XMLP.ERR_ENTITY_UNKNOWN = 14] = "Entity: unknown entity";
XMLP._errs[XMLP.ERR_INFINITELOOP	 = 15] = "Infininte loop";
XMLP._errs[XMLP.ERR_DOC_STRUCTURE	= 16] = "Document: only comments, processing instructions, or whitespace allowed outside of document element";
XMLP._errs[XMLP.ERR_ELM_NESTING	= 17] = "Element: must be nested correctly";

// =========================================================================
// =========================================================================
// =========================================================================


XMLP.prototype._addAttribute = function(name, value) {
	/*******************************************************************************************************************
	function:	 _addAttribute

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	this.m_atts[this.m_atts.length] = new Array(name, value);
}	// end function _addAttribute


XMLP.prototype._checkStructure = function(iEvent) {
	/*******************************************************************************************************************
	function:	 _checkStructure

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	if(XMLP._STATE_PROLOG == this.m_iState) {
		if((XMLP._TEXT == iEvent) || (XMLP._ENTITY == iEvent)) {
			if(SAXStrings.indexOfNonWhitespace(this.getContent(), this.getContentBegin(), this.getContentEnd()) != -1) {
				return this._setErr(XMLP.ERR_DOC_STRUCTURE);
			}
		}

		if((XMLP._ELM_B == iEvent) || (XMLP._ELM_EMP == iEvent)) {
			this.m_iState = XMLP._STATE_DOCUMENT;
			// Don't return - fall through to next state
		}
	}
	if(XMLP._STATE_DOCUMENT == this.m_iState) {
		if((XMLP._ELM_B == iEvent) || (XMLP._ELM_EMP == iEvent)) {
			this.m_stack.push(this.getName());
		}

		if((XMLP._ELM_E == iEvent) || (XMLP._ELM_EMP == iEvent)) {
			var strTop = this.m_stack.pop();
			if((strTop == null) || (strTop != this.getName())) {
				return this._setErr(XMLP.ERR_ELM_NESTING);
			}
		}

		if(this.m_stack.count() == 0) {
			this.m_iState = XMLP._STATE_MISC;
			return iEvent;
		}
	}
	if(XMLP._STATE_MISC == this.m_iState) {
		if((XMLP._ELM_B == iEvent) || (XMLP._ELM_E == iEvent) || (XMLP._ELM_EMP == iEvent) || (XMLP.EVT_DTD == iEvent)) {
			return this._setErr(XMLP.ERR_DOC_STRUCTURE);
		}

		if((XMLP._TEXT == iEvent) || (XMLP._ENTITY == iEvent)) {
			if(SAXStrings.indexOfNonWhitespace(this.getContent(), this.getContentBegin(), this.getContentEnd()) != -1) {
				return this._setErr(XMLP.ERR_DOC_STRUCTURE);
			}
		}
	}

	return iEvent;

}	// end function _checkStructure


XMLP.prototype._clearAttributes = function() {
	/*******************************************************************************************************************
	function:	 _clearAttributes

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	this.m_atts = new Array();
}	// end function _clearAttributes


XMLP.prototype._findAttributeIndex = function(name) {
	/*******************************************************************************************************************
	function:	 findAttributeIndex

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	for(var i = 0; i < this.m_atts.length; i++) {
		if(this.m_atts[i][XMLP._ATT_NAME] == name) {
			return i;
		}
	}
	return -1;

}	// end function _findAttributeIndex


XMLP.prototype.getAttributeCount = function() {
	/*******************************************************************************************************************
	function:	 getAttributeCount

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return this.m_atts ? this.m_atts.length : 0;

}	// end function getAttributeCount()


XMLP.prototype.getAttributeName = function(index) {
	/*******************************************************************************************************************
	function:	 getAttributeName

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return ((index < 0) || (index >= this.m_atts.length)) ? null : this.m_atts[index][XMLP._ATT_NAME];

}	//end function getAttributeName


XMLP.prototype.getAttributeValue = function(index) {
	/*******************************************************************************************************************
	function:	 getAttributeValue

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return ((index < 0) || (index >= this.m_atts.length)) ? null : __unescapeString(this.m_atts[index][XMLP._ATT_VAL]);

} // end function getAttributeValue


XMLP.prototype.getAttributeValueByName = function(name) {
	/*******************************************************************************************************************
	function:	 getAttributeValueByName

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return this.getAttributeValue(this._findAttributeIndex(name));

}	// end function getAttributeValueByName


XMLP.prototype.getColumnNumber = function() {
	/*******************************************************************************************************************
	function:	 getColumnNumber

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return SAXStrings.getColumnNumber(this.m_xml, this.m_iP);

}	// end function getColumnNumber


XMLP.prototype.getContent = function() {
	/*******************************************************************************************************************
	function:	 getContent

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return (this.m_cSrc == XMLP._CONT_XML) ? this.m_xml : this.m_cAlt;

}	//end function getContent


XMLP.prototype.getContentBegin = function() {
	/*******************************************************************************************************************
	function:	 getContentBegin

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return this.m_cB;

}	//end function getContentBegin


XMLP.prototype.getContentEnd = function() {
	/*******************************************************************************************************************
	function:	 getContentEnd

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return this.m_cE;

}	// end function getContentEnd


XMLP.prototype.getLineNumber = function() {
	/*******************************************************************************************************************
	function:	 getLineNumber

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return SAXStrings.getLineNumber(this.m_xml, this.m_iP);

}	// end function getLineNumber


XMLP.prototype.getName = function() {
	/*******************************************************************************************************************
	function:	 getName

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return this.m_name;

}	// end function getName()


XMLP.prototype.next = function() {
	/*******************************************************************************************************************
	function:	 next

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return this._checkStructure(this._parse());

}	// end function next()


XMLP.prototype._parse = function() {
	/*******************************************************************************************************************
	function:	 _parse

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	if(this.m_iP == this.m_xml.length) {
		return XMLP._NONE;
	}

	if(this.m_iP == this.m_xml.indexOf("<?",		this.m_iP)) {
		return this._parsePI	 (this.m_iP + 2);
	}
	else if(this.m_iP == this.m_xml.indexOf("<!DOCTYPE", this.m_iP)) {
		return this._parseDTD	(this.m_iP + 9);
	}
	else if(this.m_iP == this.m_xml.indexOf("<!--",		this.m_iP)) {
		return this._parseComment(this.m_iP + 4);
	}
	else if(this.m_iP == this.m_xml.indexOf("<![CDATA[", this.m_iP)) {
		return this._parseCDATA	(this.m_iP + 9);
	}
	else if(this.m_iP == this.m_xml.indexOf("<",		 this.m_iP)) {
		return this._parseElement(this.m_iP + 1);
	}
	else if(this.m_iP == this.m_xml.indexOf("&",		 this.m_iP)) {
		return this._parseEntity (this.m_iP + 1);
	}
	else{
		return this._parseText	 (this.m_iP);
	}


}	// end function _parse


XMLP.prototype._parseAttribute = function(iB, iE) {
	/*******************************************************************************************************************
	function:	 _parseAttribute

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	var iNB, iNE, iEq, iVB, iVE;
	var cQuote, strN, strV;

	this.m_cAlt = ""; //resets the value so we don't use an old one by accident (see testAttribute7 in the test suite)

	iNB = SAXStrings.indexOfNonWhitespace(this.m_xml, iB, iE);
	if((iNB == -1) ||(iNB >= iE)) {
		return iNB;
	}

	iEq = this.m_xml.indexOf("=", iNB);
	if((iEq == -1) || (iEq > iE)) {
		return this._setErr(XMLP.ERR_ATT_VALUES);
	}

	iNE = SAXStrings.lastIndexOfNonWhitespace(this.m_xml, iNB, iEq);

	iVB = SAXStrings.indexOfNonWhitespace(this.m_xml, iEq + 1, iE);
	if((iVB == -1) ||(iVB > iE)) {
		return this._setErr(XMLP.ERR_ATT_VALUES);
	}

	cQuote = this.m_xml.charAt(iVB);
	if(SAXStrings.QUOTES.indexOf(cQuote) == -1) {
		return this._setErr(XMLP.ERR_ATT_VALUES);
	}

	iVE = this.m_xml.indexOf(cQuote, iVB + 1);
	if((iVE == -1) ||(iVE > iE)) {
		return this._setErr(XMLP.ERR_ATT_VALUES);
	}

	strN = this.m_xml.substring(iNB, iNE + 1);
	strV = this.m_xml.substring(iVB + 1, iVE);

	if(strN.indexOf("<") != -1) {
		return this._setErr(XMLP.ERR_ATT_LT_NAME);
	}

	if(strV.indexOf("<") != -1) {
		return this._setErr(XMLP.ERR_ATT_LT_VALUE);
	}

	strV = SAXStrings.replace(strV, null, null, "\n", " ");
	strV = SAXStrings.replace(strV, null, null, "\t", " ");
	iRet = this._replaceEntities(strV);
	if(iRet == XMLP._ERROR) {
		return iRet;
	}

	strV = this.m_cAlt;

	if(this._findAttributeIndex(strN) == -1) {
		this._addAttribute(strN, strV);
	}
	else {
		return this._setErr(XMLP.ERR_ATT_DUP);
	}

	this.m_iP = iVE + 2;

	return XMLP._ATT;

}	// end function _parseAttribute


XMLP.prototype._parseCDATA = function(iB) {
	/*******************************************************************************************************************
	function:	 _parseCDATA

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	var iE = this.m_xml.indexOf("]]>", iB);
	if (iE == -1) {
		return this._setErr(XMLP.ERR_CLOSE_CDATA);
	}

	this._setContent(XMLP._CONT_XML, iB, iE);

	this.m_iP = iE + 3;

	return XMLP._CDATA;

}	// end function _parseCDATA


XMLP.prototype._parseComment = function(iB) {
	/*******************************************************************************************************************
	function:	 _parseComment

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	var iE = this.m_xml.indexOf("-" + "->", iB);
	if (iE == -1) {
		return this._setErr(XMLP.ERR_CLOSE_COMMENT);
	}

	this._setContent(XMLP._CONT_XML, iB, iE);

	this.m_iP = iE + 3;

	return XMLP._COMMENT;

}	// end function _parseComment


XMLP.prototype._parseDTD = function(iB) {
	/*******************************************************************************************************************
	function:	_parseDTD

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	// Eat DTD

	var iE, strClose, iInt, iLast;

	iE = this.m_xml.indexOf(">", iB);
	if(iE == -1) {
		return this._setErr(XMLP.ERR_CLOSE_DTD);
	}

	iInt = this.m_xml.indexOf("[", iB);
	strClose = ((iInt != -1) && (iInt < iE)) ? "]>" : ">";

	while(true) {
		// DEBUG: Remove
		if(iE == iLast) {
			return this._setErr(XMLP.ERR_INFINITELOOP);
		}

		iLast = iE;
		// DEBUG: Remove End

		iE = this.m_xml.indexOf(strClose, iB);
		if(iE == -1) {
			return this._setErr(XMLP.ERR_CLOSE_DTD);
		}

		// Make sure it is not the end of a CDATA section
		if (this.m_xml.substring(iE - 1, iE + 2) != "]]>") {
			break;
		}
	}

	this.m_iP = iE + strClose.length;

	return XMLP._DTD;

}	// end function _parseDTD


XMLP.prototype._parseElement = function(iB) {
	/*******************************************************************************************************************
	function:	 _parseElement

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	var iE, iDE, iNE, iRet;
	var iType, strN, iLast;

	iDE = iE = this.m_xml.indexOf(">", iB);
	if(iE == -1) {
		return this._setErr(XMLP.ERR_CLOSE_ELM);
	}

	if(this.m_xml.charAt(iB) == "/") {
		iType = XMLP._ELM_E;
		iB++;
	} else {
		iType = XMLP._ELM_B;
	}

	if(this.m_xml.charAt(iE - 1) == "/") {
		if(iType == XMLP._ELM_E) {
			return this._setErr(XMLP.ERR_ELM_EMPTY);
		}
		iType = XMLP._ELM_EMP;
		iDE--;
	}

	iDE = SAXStrings.lastIndexOfNonWhitespace(this.m_xml, iB, iDE);

	//djohack
	//hack to allow for elements with single character names to be recognized

	if (iE - iB != 1 ) {
		if(SAXStrings.indexOfNonWhitespace(this.m_xml, iB, iDE) != iB) {
			return this._setErr(XMLP.ERR_ELM_NAME);
		}
	}
	// end hack -- original code below

	/*
	if(SAXStrings.indexOfNonWhitespace(this.m_xml, iB, iDE) != iB)
		return this._setErr(XMLP.ERR_ELM_NAME);
	*/
	this._clearAttributes();

	iNE = SAXStrings.indexOfWhitespace(this.m_xml, iB, iDE);
	if(iNE == -1) {
		iNE = iDE + 1;
	}
	else {
		this.m_iP = iNE;
		while(this.m_iP < iDE) {
			// DEBUG: Remove
			if(this.m_iP == iLast) return this._setErr(XMLP.ERR_INFINITELOOP);
			iLast = this.m_iP;
			// DEBUG: Remove End


			iRet = this._parseAttribute(this.m_iP, iDE);
			if(iRet == XMLP._ERROR) return iRet;
		}
	}

	strN = this.m_xml.substring(iB, iNE);

	if(strN.indexOf("<") != -1) {
		return this._setErr(XMLP.ERR_ELM_LT_NAME);
	}

	this.m_name = strN;
	this.m_iP = iE + 1;

	return iType;

}	// end function _parseElement


XMLP.prototype._parseEntity = function(iB) {
	/*******************************************************************************************************************
	function:	 _parseEntity

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	var iE = this.m_xml.indexOf(";", iB);
	if(iE == -1) {
		return this._setErr(XMLP.ERR_CLOSE_ENTITY);
	}

	this.m_iP = iE + 1;

	return this._replaceEntity(this.m_xml, iB, iE);

}	// end function _parseEntity


XMLP.prototype._parsePI = function(iB) {
	/*******************************************************************************************************************
	function:	 _parsePI

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	var iE, iTB, iTE, iCB, iCE;

	iE = this.m_xml.indexOf("?>", iB);
	if(iE	 == -1) {
		return this._setErr(XMLP.ERR_CLOSE_PI);
	}

	iTB = SAXStrings.indexOfNonWhitespace(this.m_xml, iB, iE);
	if(iTB == -1) {
		return this._setErr(XMLP.ERR_PI_TARGET);
	}

	iTE = SAXStrings.indexOfWhitespace(this.m_xml, iTB, iE);
	if(iTE	== -1) {
		iTE = iE;
	}

	iCB = SAXStrings.indexOfNonWhitespace(this.m_xml, iTE, iE);
	if(iCB == -1) {
		iCB = iE;
	}

	iCE = SAXStrings.lastIndexOfNonWhitespace(this.m_xml, iCB, iE);
	if(iCE	== -1) {
		iCE = iE - 1;
	}

	this.m_name = this.m_xml.substring(iTB, iTE);
	this._setContent(XMLP._CONT_XML, iCB, iCE + 1);
	this.m_iP = iE + 2;

	return XMLP._PI;

}	// end function _parsePI


XMLP.prototype._parseText = function(iB) {
	/*******************************************************************************************************************
	function:	 _parseText

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	var iE, iEE;

	iE = this.m_xml.indexOf("<", iB);
	if(iE == -1) {
		iE = this.m_xml.length;
	}

	iEE = this.m_xml.indexOf("&", iB);
	if((iEE != -1) && (iEE <= iE)) {
		iE = iEE;
	}

	this._setContent(XMLP._CONT_XML, iB, iE);

	this.m_iP = iE;

	return XMLP._TEXT;

} // end function _parseText


XMLP.prototype._replaceEntities = function(strD, iB, iE) {
	/*******************************************************************************************************************
	function:	 _replaceEntities

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	if(SAXStrings.isEmpty(strD)) return "";
	iB = iB || 0;
	iE = iE || strD.length;


	var iEB, iEE, strRet = "";

	iEB = strD.indexOf("&", iB);
	iEE = iB;

	while((iEB > 0) && (iEB < iE)) {
		strRet += strD.substring(iEE, iEB);

		iEE = strD.indexOf(";", iEB) + 1;

		if((iEE == 0) || (iEE > iE)) {
			return this._setErr(XMLP.ERR_CLOSE_ENTITY);
		}

		iRet = this._replaceEntity(strD, iEB + 1, iEE - 1);
		if(iRet == XMLP._ERROR) {
			return iRet;
		}

		strRet += this.m_cAlt;

		iEB = strD.indexOf("&", iEE);
	}

	if(iEE != iE) {
		strRet += strD.substring(iEE, iE);
	}

	this._setContent(XMLP._CONT_ALT, strRet);

	return XMLP._ENTITY;

}	// end function _replaceEntities


XMLP.prototype._replaceEntity = function(strD, iB, iE) {
	/*******************************************************************************************************************
	function:	 _replaceEntity

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	if(SAXStrings.isEmpty(strD)) return -1;
	iB = iB || 0;
	iE = iE || strD.length;

	switch(strD.substring(iB, iE)) {
		case "amp":	strEnt = "&";	break;
		case "lt":	 strEnt = "<";	break;
		case "gt":	 strEnt = ">";	break;
		case "apos": strEnt = "'";	break;
		case "quot": strEnt = "\""; break;
		default:
			if(strD.charAt(iB) == "#") {
				strEnt = String.fromCharCode(parseInt(strD.substring(iB + 1, iE)));
			} else {
				return this._setErr(XMLP.ERR_ENTITY_UNKNOWN);
			}
		break;
	}
	this._setContent(XMLP._CONT_ALT, strEnt);

	return XMLP._ENTITY;
}	// end function _replaceEntity


XMLP.prototype._setContent = function(iSrc) {
	/*******************************************************************************************************************
	function:	 _setContent

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	var args = arguments;

	if(XMLP._CONT_XML == iSrc) {
		this.m_cAlt = null;
		this.m_cB = args[1];
		this.m_cE = args[2];
	} else {
		this.m_cAlt = args[1];
		this.m_cB = 0;
		this.m_cE = args[1].length;
	}
	this.m_cSrc = iSrc;

}	// end function _setContent


XMLP.prototype._setErr = function(iErr) {
	/*******************************************************************************************************************
	function:	 _setErr

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	var strErr = XMLP._errs[iErr];

	this.m_cAlt = strErr;
	this.m_cB = 0;
	this.m_cE = strErr.length;
	this.m_cSrc = XMLP._CONT_ALT;

	return XMLP._ERROR;

}	// end function _setErr






/***************************************************************************************************************
SAXDriver is an object that basically wraps an XMLP instance, and provides an
event-based interface for parsing. This is the object users interact with when coding
with XML for <SCRIPT>
*****************************************************************************************************************/


SAXDriver = function() {
	/*******************************************************************************************************************
	function:	 SAXDriver

	Author:	 Scott Severtson

	Description:
		This is the constructor for the SAXDriver Object
	*********************************************************************************************************************/
	this.m_hndDoc = null;
	this.m_hndErr = null;
	this.m_hndLex = null;
}


// CONSTANTS	(these must be below the constructor)

// =========================================================================
// =========================================================================
// =========================================================================
SAXDriver.DOC_B = 1;
SAXDriver.DOC_E = 2;
SAXDriver.ELM_B = 3;
SAXDriver.ELM_E = 4;
SAXDriver.CHARS = 5;
SAXDriver.PI	= 6;
SAXDriver.CD_B	= 7;
SAXDriver.CD_E	= 8;
SAXDriver.CMNT	= 9;
SAXDriver.DTD_B = 10;
SAXDriver.DTD_E = 11;
// =========================================================================
// =========================================================================
// =========================================================================



SAXDriver.prototype.parse = function(strD) {
	/*******************************************************************************************************************
	function:	 parse

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	var parser = new XMLP(strD);

	if(this.m_hndDoc && this.m_hndDoc.setDocumentLocator) {
		this.m_hndDoc.setDocumentLocator(this);
	}

	this.m_parser = parser;
	this.m_bErr = false;

	if(!this.m_bErr) {
		this._fireEvent(SAXDriver.DOC_B);
	}
	this._parseLoop();
	if(!this.m_bErr) {
		this._fireEvent(SAXDriver.DOC_E);
	}

	this.m_xml = null;
	this.m_iP = 0;

}	// end function parse


SAXDriver.prototype.setDocumentHandler = function(hnd) {
	/*******************************************************************************************************************
	function:	 setDocumentHandler

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	this.m_hndDoc = hnd;

}	 // end function setDocumentHandler


SAXDriver.prototype.setErrorHandler = function(hnd) {
	/*******************************************************************************************************************
	function:	 setErrorHandler

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	this.m_hndErr = hnd;

}	// end function setErrorHandler


SAXDriver.prototype.setLexicalHandler = function(hnd) {
	/*******************************************************************************************************************
	function:	 setLexicalHandler

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	this.m_hndLex = hnd;

}	// end function setLexicalHandler


	/*******************************************************************************************************************
												LOCATOR/PARSE EXCEPTION INTERFACE
	*********************************************************************************************************************/

SAXDriver.prototype.getColumnNumber = function() {
	/*******************************************************************************************************************
	function:	 getSystemId

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return this.m_parser.getColumnNumber();

}	// end function getColumnNumber


SAXDriver.prototype.getLineNumber = function() {
	/*******************************************************************************************************************
	function:	 getLineNumber

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return this.m_parser.getLineNumber();

}	// end function getLineNumber


SAXDriver.prototype.getMessage = function() {
	/*******************************************************************************************************************
	function:	 getMessage

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return this.m_strErrMsg;

}	// end function getMessage


SAXDriver.prototype.getPublicId = function() {
	/*******************************************************************************************************************
	function:	 getPublicID

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return null;

}	// end function getPublicID


SAXDriver.prototype.getSystemId = function() {
	/*******************************************************************************************************************
	function:	 getSystemId

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return null;

}	// end function getSystemId


	/*******************************************************************************************************************
												Attribute List Interface
	*********************************************************************************************************************/

SAXDriver.prototype.getLength = function() {
	/*******************************************************************************************************************
	function:	 getLength

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return this.m_parser.getAttributeCount();

}	// end function getAttributeCount


SAXDriver.prototype.getName = function(index) {
	/*******************************************************************************************************************
	function:	 getName

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return this.m_parser.getAttributeName(index);

} // end function getAttributeName


SAXDriver.prototype.getValue = function(index) {
	/*******************************************************************************************************************
	function:	 getValue

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return this.m_parser.getAttributeValue(index);

}	// end function getAttributeValue


SAXDriver.prototype.getValueByName = function(name) {
	/*******************************************************************************************************************
	function:	 getValueByName

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return this.m_parser.getAttributeValueByName(name);

} // end function getAttributeValueByName


	/*******************************************************************************************************************
																Private functions
	*********************************************************************************************************************/

SAXDriver.prototype._fireError = function(strMsg) {
	/*******************************************************************************************************************
	function:	 _fireError

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	this.m_strErrMsg = strMsg;
	this.m_bErr = true;

	if(this.m_hndErr && this.m_hndErr.fatalError) {
		this.m_hndErr.fatalError(this);
	}

}	 // end function _fireError


SAXDriver.prototype._fireEvent = function(iEvt) {
	/*******************************************************************************************************************
	function:	 _fireEvent

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	var hnd, func, args = arguments, iLen = args.length - 1;

	if(this.m_bErr) return;

	if(SAXDriver.DOC_B == iEvt) {
		func = "startDocument";		 hnd = this.m_hndDoc;
	}
	else if (SAXDriver.DOC_E == iEvt) {
		func = "endDocument";			 hnd = this.m_hndDoc;
	}
	else if (SAXDriver.ELM_B == iEvt) {
		func = "startElement";			hnd = this.m_hndDoc;
	}
	else if (SAXDriver.ELM_E == iEvt) {
		func = "endElement";			hnd = this.m_hndDoc;
	}
	else if (SAXDriver.CHARS == iEvt) {
		func = "characters";			hnd = this.m_hndDoc;
	}
	else if (SAXDriver.PI	== iEvt) {
		func = "processingInstruction"; hnd = this.m_hndDoc;
	}
	else if (SAXDriver.CD_B	== iEvt) {
		func = "startCDATA";			hnd = this.m_hndLex;
	}
	else if (SAXDriver.CD_E	== iEvt) {
		func = "endCDATA";				hnd = this.m_hndLex;
	}
	else if (SAXDriver.CMNT	== iEvt) {
		func = "comment";				 hnd = this.m_hndLex;
	}

	if(hnd && hnd[func]) {
		if(0 == iLen) {
			hnd[func]();
		}
		else if (1 == iLen) {
			hnd[func](args[1]);
		}
		else if (2 == iLen) {
			hnd[func](args[1], args[2]);
		}
		else if (3 == iLen) {
			hnd[func](args[1], args[2], args[3]);
		}
	}

}	// end function _fireEvent


SAXDriver.prototype._parseLoop = function(parser) {
	/*******************************************************************************************************************
	function:	 _parseLoop

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	var iEvent, parser;

	parser = this.m_parser;
	while(!this.m_bErr) {
		iEvent = parser.next();

		if(iEvent == XMLP._ELM_B) {
			this._fireEvent(SAXDriver.ELM_B, parser.getName(), this);
		}
		else if(iEvent == XMLP._ELM_E) {
			this._fireEvent(SAXDriver.ELM_E, parser.getName());
		}
		else if(iEvent == XMLP._ELM_EMP) {
			this._fireEvent(SAXDriver.ELM_B, parser.getName(), this);
			this._fireEvent(SAXDriver.ELM_E, parser.getName());
		}
		else if(iEvent == XMLP._TEXT) {
			this._fireEvent(SAXDriver.CHARS, parser.getContent(), parser.getContentBegin(), parser.getContentEnd() - parser.getContentBegin());
		}
		else if(iEvent == XMLP._ENTITY) {
			this._fireEvent(SAXDriver.CHARS, parser.getContent(), parser.getContentBegin(), parser.getContentEnd() - parser.getContentBegin());
		}
		else if(iEvent == XMLP._PI) {
			this._fireEvent(SAXDriver.PI, parser.getName(), parser.getContent().substring(parser.getContentBegin(), parser.getContentEnd()));
		}
		else if(iEvent == XMLP._CDATA) {
			this._fireEvent(SAXDriver.CD_B);
			this._fireEvent(SAXDriver.CHARS, parser.getContent(), parser.getContentBegin(), parser.getContentEnd() - parser.getContentBegin());
			this._fireEvent(SAXDriver.CD_E);
		}
		else if(iEvent == XMLP._COMMENT) {
			this._fireEvent(SAXDriver.CMNT, parser.getContent(), parser.getContentBegin(), parser.getContentEnd() - parser.getContentBegin());
		}
		else if(iEvent == XMLP._DTD) {
		}
		else if(iEvent == XMLP._ERROR) {
			this._fireError(parser.getContent());
		}
		else if(iEvent == XMLP._NONE) {
			return;
		}
	}

}	// end function _parseLoop



/***************************************************************************************************************
SAXStrings: a useful object containing string manipulation functions
*****************************************************************************************************************/


SAXStrings = function() {
	/*******************************************************************************************************************
	function:	 SAXStrings

	Author:	 Scott Severtson

	Description:
		This is the constructor of the SAXStrings object
	*********************************************************************************************************************/
}	// end function SAXStrings


// CONSTANTS	(these must be below the constructor)

// =========================================================================
// =========================================================================
// =========================================================================
SAXStrings.WHITESPACE = " \t\n\r";
SAXStrings.QUOTES = "\"'";
// =========================================================================
// =========================================================================
// =========================================================================


SAXStrings.getColumnNumber = function(strD, iP) {
	/*******************************************************************************************************************
	function:	 replace

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	if(SAXStrings.isEmpty(strD)) {
		return -1;
	}
	iP = iP || strD.length;

	var arrD = strD.substring(0, iP).split("\n");
	var strLine = arrD[arrD.length - 1];
	arrD.length--;
	var iLinePos = arrD.join("\n").length;

	return iP - iLinePos;

}	// end function getColumnNumber


SAXStrings.getLineNumber = function(strD, iP) {
	/*******************************************************************************************************************
	function:	 getLineNumber

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	if(SAXStrings.isEmpty(strD)) {
		return -1;
	}
	iP = iP || strD.length;

	return strD.substring(0, iP).split("\n").length
}	// end function getLineNumber


SAXStrings.indexOfNonWhitespace = function(strD, iB, iE) {
	/*******************************************************************************************************************
	function:	 indexOfNonWhitespace

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	if(SAXStrings.isEmpty(strD)) {
		return -1;
	}
	iB = iB || 0;
	iE = iE || strD.length;

	for(var i = iB; i < iE; i++){
		if(SAXStrings.WHITESPACE.indexOf(strD.charAt(i)) == -1) {
			return i;
		}
	}
	return -1;

}	// end function indexOfNonWhitespace


SAXStrings.indexOfWhitespace = function(strD, iB, iE) {
	/*******************************************************************************************************************
	function:	 indexOfWhitespace

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	if(SAXStrings.isEmpty(strD)) {
		return -1;
	}
	iB = iB || 0;
	iE = iE || strD.length;

	for(var i = iB; i < iE; i++) {
		if(SAXStrings.WHITESPACE.indexOf(strD.charAt(i)) != -1) {
			return i;
		}
	}
	return -1;
}	// end function indexOfWhitespace


SAXStrings.isEmpty = function(strD) {
	/*******************************************************************************************************************
	function:	 isEmpty

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return (strD == null) || (strD.length == 0);

}	// end function isEmpty


SAXStrings.lastIndexOfNonWhitespace = function(strD, iB, iE) {
	/*******************************************************************************************************************
	function:	 lastIndexOfNonWhiteSpace

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	if(SAXStrings.isEmpty(strD)) {
		return -1;
	}
	iB = iB || 0;
	iE = iE || strD.length;

	for(var i = iE - 1; i >= iB; i--){
		if(SAXStrings.WHITESPACE.indexOf(strD.charAt(i)) == -1){
			return i;
		}
	}
	return -1;
}	// end function lastIndexOfNonWhitespace


SAXStrings.replace = function(strD, iB, iE, strF, strR) {
	/*******************************************************************************************************************
	function:	 replace

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	if(SAXStrings.isEmpty(strD)) {
		return "";
	}
	iB = iB || 0;
	iE = iE || strD.length;

	return strD.substring(iB, iE).split(strF).join(strR);

}	// end function replace



/***************************************************************************************************************
Stack: A simple stack class, used for verifying document structure.
*****************************************************************************************************************/

Stack = function() {
	/*******************************************************************************************************************
	function:	 Stack

	Author:	 Scott Severtson

	Description:
		Constructor of the Stack Object
	*********************************************************************************************************************/
	this.m_arr = new Array();

}	// end function Stack


Stack.prototype.clear = function() {
	/*******************************************************************************************************************
	function:	 clear

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	this.m_arr = new Array();

}	// end function clear


Stack.prototype.count = function() {
	/*******************************************************************************************************************
	function:	 count

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	return this.m_arr.length;

}	// end function count


Stack.prototype.destroy = function() {
	/*******************************************************************************************************************
	function:	 destroy

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	this.m_arr = null;

}	 // end function destroy


Stack.prototype.peek = function() {
	/*******************************************************************************************************************
	function:	 peek

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	if(this.m_arr.length == 0) {
		return null;
	}

	return this.m_arr[this.m_arr.length - 1];

}	// end function peek


Stack.prototype.pop = function() {
	/*******************************************************************************************************************
	function:	 pop

	Author:	 Scott Severtson
	*********************************************************************************************************************/
	if(this.m_arr.length == 0) {
		return null;
	}

	var o = this.m_arr[this.m_arr.length - 1];
	this.m_arr.length--;
	return o;

}	// end function pop


Stack.prototype.push = function(o) {
	/*******************************************************************************************************************
	function:	 push

	Author:	 Scott Severtson
	*********************************************************************************************************************/

	this.m_arr[this.m_arr.length] = o;

}	// end function push



// =========================================================================
// =========================================================================
// =========================================================================

// CONVENIENCE FUNCTIONS

// =========================================================================
// =========================================================================
// =========================================================================

function isEmpty(str) {
	/*******************************************************************************************************************
	function: isEmpty

	Author: mike@idle.org

	Description:
		convenience function to identify an empty string

	*********************************************************************************************************************/
	return (str==null) || (str.length==0);

} // end function isEmpty



function trim(trimString, leftTrim, rightTrim) {
	/*******************************************************************************************************************
	function: trim

	Author: may106@psu.edu

	Description:
		helper function to trip a string (trimString) of leading (leftTrim)
		and trailing (rightTrim) whitespace

	*********************************************************************************************************************/
	if (isEmpty(trimString)) {
		return "";
	}

	// the general focus here is on minimal method calls - hence only one
	// substring is done to complete the trim.

	if (leftTrim == null) {
		leftTrim = true;
	}

	if (rightTrim == null) {
		rightTrim = true;
	}

	var left=0;
	var right=0;
	var i=0;
	var k=0;


	// modified to properly handle strings that are all whitespace
	if (leftTrim == true) {
		while ((i<trimString.length) && (whitespace.indexOf(trimString.charAt(i++))!=-1)) {
			left++;
		}
	}
	if (rightTrim == true) {
		k=trimString.length-1;
		while((k>=left) && (whitespace.indexOf(trimString.charAt(k--))!=-1)) {
			right++;
		}
	}
	return trimString.substring(left, trimString.length - right);
} // end function trim

/**
 * function __escapeString
 *
 * author: David Joham djoham@yahoo.com
 *
 * @param	str : string - The string to be escaped
 *
 * @return : string - The escaped string
 */
function __escapeString(str) {

	var escAmpRegEx = /&/g;
	var escLtRegEx = /</g;
	var escGtRegEx = />/g;
	var quotRegEx = /"/g;
	var aposRegEx = /'/g;

	str = str.replace(escAmpRegEx, "&amp;");
	str = str.replace(escLtRegEx, "&lt;");
	str = str.replace(escGtRegEx, "&gt;");
	str = str.replace(quotRegEx, "&quot;");
	str = str.replace(aposRegEx, "&apos;");

	return str;
}

/**
 * function __unescapeString 
 *
 * author: David Joham djoham@yahoo.com
 *
 * @param	str : string - The string to be unescaped
 *
 * @return : string - The unescaped string
 */
function __unescapeString(str) {

	var escAmpRegEx = /&amp;/g;
	var escLtRegEx = /&lt;/g;
	var escGtRegEx = /&gt;/g;
	var quotRegEx = /&quot;/g;
	var aposRegEx = /&apos;/g;

	str = str.replace(escAmpRegEx, "&");
	str = str.replace(escLtRegEx, "<");
	str = str.replace(escGtRegEx, ">");
	str = str.replace(quotRegEx, "\"");
	str = str.replace(aposRegEx, "'");

	return str;
}


// =========================================================================
//
// xmldom.js - an XML DOM parser in JavaScript.
//
//	This is the classic DOM that has shipped with XML for <SCRIPT>
//	since the beginning. For a more standards-compliant DOM, you may
//	wish to use the standards-compliant W3C DOM that is included
//	with XML for <SCRIPT> versions 3.0 and above
//
// version 3.1
//
// =========================================================================
//
// Copyright (C) 2000 - 2002, 2003 Michael Houghton (mike@idle.org), Raymond Irving and David Joham (djoham@yahoo.com)
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.

// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
// Lesser General Public License for more details.

// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA	02111-1307	USA
//
//
// Visit the XML for <SCRIPT> home page at http://xmljs.sourceforge.net
//


// =========================================================================
// =========================================================================
// =========================================================================

// CONSTANTS

// =========================================================================
// =========================================================================
// =========================================================================

//define the characters which constitute whitespace, and quotes
var whitespace = "\n\r\t ";
var quotes = "\"'";


// =========================================================================
// =========================================================================
// =========================================================================

// CONVENIENCE FUNCTIONS

// =========================================================================
// =========================================================================
// =========================================================================


function convertEscapes(str) {
	/*******************************************************************************************************************
	function: convertEscapes

	Author: David Joham <djoham@yahoo.com>

	Description:
		Characters such as less-than signs, greater-than signs and ampersands are
		illegal in XML syntax and must be escaped before being inserted into the DOM.
		This function is a convience function to take those escaped characters and
		return them to their original values for processing outside the parser

		This XML Parser automagically converts the content of the XML elements to
		their non-escaped values when xmlNode.getText() is called for every element
		except CDATA.

		EXAMPLES:

		&amp; == &
		&lt; == <
		&gt; == >

	*********************************************************************************************************************/
	// not all Konqueror installations have regex support for some reason. Here's the original code using regexes
	// that is probably a little more efficient if it matters to you
	/*
	var escAmpRegEx = /&amp;/g;
	var escLtRegEx = /&lt;/g;
	var escGtRegEx = /&gt;/g;

	str = str.replace(escAmpRegEx, "&");
	str = str.replace(escLtRegEx, "<");
	str = str.replace(escGtRegEx, ">");
	*/
	var gt;

	//&lt;
	gt = -1;
	while (str.indexOf("&lt;", gt + 1) > -1) {
		var gt = str.indexOf("&lt;", gt + 1);
		var newStr = str.substr(0, gt);
		newStr += "<";
		newStr = newStr + str.substr(gt + 4, str.length);
		str = newStr;
	}

	//&gt;
	gt = -1;
	while (str.indexOf("&gt;", gt + 1) > -1) {
		var gt = str.indexOf("&gt;", gt + 1);
		var newStr = str.substr(0, gt);
		newStr += ">";
		newStr = newStr + str.substr(gt + 4, str.length);
		str = newStr;
	}

	//&amp;
	gt = -1;
	while (str.indexOf("&amp;", gt + 1) > -1) {
		var gt = str.indexOf("&amp;", gt + 1);
		var newStr = str.substr(0, gt);
		newStr += "&";
		newStr = newStr + str.substr(gt + 5, str.length);
		str = newStr;
	}

	return str;
} // end function convertEscapes


function convertToEscapes(str) {
	/*******************************************************************************************************************
	function: convertToEscapes

	Author: David Joham djoham@yahoo.com

	Description:
		Characters such as less-than signs, greater-than signs and ampersands are
		illegal in XML syntax. This function is a convience function to escape those
		characters out to there legal values.

		EXAMPLES:

		< == &lt;
		> == &gt;
		& == &amp;
	*********************************************************************************************************************/
	// not all Konqueror installations have regex support for some reason. Here's the original code using regexes
	// that is probably a little more efficient if it matters to you
	/*
	var escAmpRegEx = /&/g;
	var escLtRegEx = /</g;
	var escGtRegEx = />/g;
	str = str.replace(escAmpRegEx, "&amp;");
	str = str.replace(escLtRegEx, "&lt;");
	str = str.replace(escGtRegEx, "&gt;");
	*/

	// start with &
	var gt = -1;
	while (str.indexOf("&", gt + 1) > -1) {
		gt = str.indexOf("&", gt + 1);
		var newStr = str.substr(0, gt);
		newStr += "&amp;";
		newStr = newStr + str.substr(gt + 1, str.length);
		str = newStr;
	}

	// now <
	gt = -1;
	while (str.indexOf("<", gt + 1) > -1) {
		var gt = str.indexOf("<", gt + 1);
		var newStr = str.substr(0, gt);
		newStr += "&lt;";
		newStr = newStr + str.substr(gt + 1, str.length);
		str = newStr;
	}

	//now >
	gt = -1;
	while (str.indexOf(">", gt + 1) > -1) {
		var gt = str.indexOf(">", gt + 1);
		var newStr = str.substr(0, gt);
		newStr += "&gt;";
		newStr = newStr + str.substr(gt + 1, str.length);
		str = newStr;
	}


	return str;
} // end function convertToEscapes


function _displayElement(domElement, strRet) {
	/*******************************************************************************************************************
	function:		 _displayElement

	Author: djoham@yahoo.com

	Description:
		returns the XML string associated with the DOM element passed in
		recursively calls itself if child elements are found

	*********************************************************************************************************************/
	if(domElement==null) {
		return;
	}
	if(!(domElement.nodeType=='ELEMENT')) {
		return;
	}

	var tagName = domElement.tagName;
	var tagInfo = "";
	tagInfo = "<" + tagName;

	// attributes
	var attributeList = domElement.getAttributeNames();

	for(var intLoop = 0; intLoop < attributeList.length; intLoop++) {
		var attribute = attributeList[intLoop];
		tagInfo = tagInfo + " " + attribute + "=";
		tagInfo = tagInfo + "\"" + domElement.getAttribute(attribute) + "\"";
	}

	//close the element name
	tagInfo = tagInfo + ">";

	strRet=strRet+tagInfo;

	// children
	if(domElement.children!=null) {
		var domElements = domElement.children;
		for(var intLoop = 0; intLoop < domElements.length; intLoop++) {
			var childNode = domElements[intLoop];
			if(childNode.nodeType=='COMMENT') {
				strRet = strRet + "<!--" + childNode.content + "-->";
			}

			else if(childNode.nodeType=='TEXT') {
				var cont = trim(childNode.content,true,true);
				strRet = strRet + childNode.content;
			}

			else if (childNode.nodeType=='CDATA') {
				var cont = trim(childNode.content,true,true);
				strRet = strRet + "<![CDATA[" + cont + "]]>";
			}

			else {
				strRet = _displayElement(childNode, strRet);
			}
		} // end looping through the DOM elements
	} // end checking for domElements.children = null

	//ending tag
	strRet = strRet + "</" + tagName + ">";
	return strRet;
} // end function displayElement


function firstWhiteChar(str,pos) {
	/*******************************************************************************************************************
	function: firstWhiteChar

	Author: may106@psu.edu ?

	Description:
		return the position of the first whitespace character in str after position pos

	*********************************************************************************************************************/
	if (isEmpty(str)) {
		return -1;
	}

	while(pos < str.length) {
		if (whitespace.indexOf(str.charAt(pos))!=-1) {
			return pos;
		}
		else {
			pos++;
		}
	}
	return str.length;
} // end function firstWhiteChar


function isEmpty(str) {
	/*******************************************************************************************************************
	function: isEmpty

	Author: mike@idle.org

	Description:
		convenience function to identify an empty string

	*********************************************************************************************************************/
	return (str==null) || (str.length==0);

} // end function isEmpty

function trim(trimString, leftTrim, rightTrim) {
	/*******************************************************************************************************************
	function: trim

	Author: may106@psu.edu

	Description:
		helper function to trip a string (trimString) of leading (leftTrim)
		and trailing (rightTrim) whitespace

	*********************************************************************************************************************/
	if (isEmpty(trimString)) {
		return "";
	}

	// the general focus here is on minimal method calls - hence only one
	// substring is done to complete the trim.

	if (leftTrim == null) {
		leftTrim = true;
	}

	if (rightTrim == null) {
		rightTrim = true;
	}

	var left=0;
	var right=0;
	var i=0;
	var k=0;

	// modified to properly handle strings that are all whitespace
	if (leftTrim == true) {
		while ((i<trimString.length) && (whitespace.indexOf(trimString.charAt(i++))!=-1)) {
			left++;
		}
	}
	if (rightTrim == true) {
		k=trimString.length-1;
		while((k>=left) && (whitespace.indexOf(trimString.charAt(k--))!=-1)) {
			right++;
		}
	}
	return trimString.substring(left, trimString.length - right);
} // end function trim









// =========================================================================
// =========================================================================
// =========================================================================
// XML DOC FUNCTIONS
// =========================================================================
// =========================================================================
// =========================================================================

function XMLDoc(source, errFn) {
	/*******************************************************************************************************************
	function:		 XMLDoc

	Author: mike@idle.org

	Description:
		a constructor for an XML document
		source: the string containing the document
		errFn: the (optional) function used to log errors
	*********************************************************************************************************************/
	// stack for document construction

	this.topNode=null;

	// set up the properties and methods for this object

	this.errFn = errFn;			// user defined error functions

	this.createXMLNode = _XMLDoc_createXMLNode;
	this.error = _XMLDoc_error;
	this.getUnderlyingXMLText = _XMLDoc_getUnderlyingXMLText;
	this.handleNode = _XMLDoc_handleNode;
	this.hasErrors = false;		// were errors found during the parse?
	this.insertNodeAfter =	_XMLDoc_insertNodeAfter;
	this.insertNodeInto = _XMLDoc_insertNodeInto;
	this.loadXML = _XMLDoc_loadXML;
	this.parse = _XMLDoc_parse;
	this.parseAttribute = _XMLDoc_parseAttribute;
	this.parseDTD = _XMLDoc_parseDTD;
	this.parsePI = _XMLDoc_parsePI;
	this.parseTag = _XMLDoc_parseTag;
	this.removeNodeFromTree = _XMLDoc_removeNodeFromTree;
	this.replaceNodeContents = _XMLDoc_replaceNodeContents;
	this.selectNode = _XMLDoc_selectNode;
	this.selectNodeText = _XMLDoc_selectNodeText;
	this.source = source;		// the string source of the document

	// parse the document

	if (this.parse()) {
		// we've run out of markup - check the stack is now empty
		if (this.topNode!=null) {
			return this.error("expected close " + this.topNode.tagName);
		}
		else {
			return true;
		}
	}
} // end function XMLDoc


function _XMLDoc_createXMLNode(strXML) {
	/*******************************************************************************************************************
	function:	 _XMLDoc_createXMLNode

	Author: djoham@yahoo.com

	Description:
		convienience function to create a new node that inherits
		the properties of the document object
	*********************************************************************************************************************/
	return new XMLDoc(strXML, this.errFn).docNode;

} // end function _XMLDoc_createXMLNode


function _XMLDoc_error(str) {
	/*******************************************************************************************************************
	function:		 _XMLDoc_error

	Author: mike@idle.org

	Description:
		used to log an error in parsing or validating
	*********************************************************************************************************************/

	this.hasErrors=true;
	if(this.errFn){
		this.errFn("ERROR: " + str);
	}else if(this.onerror){
		this.onerror("ERROR: " + str); 
	}
	return 0;

} // end function _XMLDoc_error


function _XMLDoc_getTagNameParams(tag,obj){
	/*******************************************************************************************************************
	function:		 _XMLDoc_getTagNameParams

	Author: xwisdom@yahoo.com

	Description:
		convienience function for the nodeSearch routines
	*********************************************************************************************************************/
	var elm=-1,e,s=tag.indexOf('[');
	var attr=[];
	if(s>=0){
		e=tag.indexOf(']');
		if(e>=0)elm=tag.substr(s+1,(e-s)-1);
		else obj.error('expected ] near '+tag);
		tag=tag.substr(0,s);
		if(isNaN(elm) && elm!='*'){
			attr=elm.substr(1,elm.length-1); // remove @
			attr=attr.split('=');
			if(attr[1]) { //remove "
				s=attr[1].indexOf('"');
				attr[1]=attr[1].substr(s+1,attr[1].length-1);
				e=attr[1].indexOf('"');
				if(e>=0) attr[1]=attr[1].substr(0,e);
				else obj.error('expected " near '+tag)
			};elm=-1;
		}else if(elm=='*') elm=-1;
	}
	return [tag,elm,attr[0],attr[1]]
} // end function _XMLDoc_getTagNameParams


function _XMLDoc_getUnderlyingXMLText() {
	/*******************************************************************************************************************
	function:		 _XMLDoc_getUnderlyingXMLText

	Author: djoham@yahoo.com

	Description:
		kicks off the process that returns the XML text representation of the XML
		document inclusive of any changes made by the manipulation of the DOM
	*********************************************************************************************************************/
	var strRet = "";
	//for now, hardcode the xml version 1 information. When we handle Processing Instructions later, this
	//should be looked at again
	strRet = strRet + "<?xml version=\"1.0\"?>";
	if (this.docNode==null) {
		return;
	}

	strRet = _displayElement(this.docNode, strRet);
	return strRet;

} // end function _XMLDoc_getCurrentXMLText



function _XMLDoc_handleNode(current) {
	/*******************************************************************************************************************
	function:	 _XMLDoc_handleNode

	Author: mike@idle.org

	Description:
		adds a markup element to the document
	*********************************************************************************************************************/

	if ((current.nodeType=='COMMENT') && (this.topNode!=null)) {
		return this.topNode.addElement(current);
	}
	else if ((current.nodeType=='TEXT') ||	(current.nodeType=='CDATA')) {

		// if the current node is a text node:


		// if the stack is empty, and this text node isn't just whitespace, we have
		// a problem (we're not in a document element)

		if(this.topNode==null) {
			if (trim(current.content,true,false)=="") {
				return true;
			}
			else {
				return this.error("expected document node, found: " + current);
			}
		}
		else {
			// otherwise, append this as child to the element at the top of the stack
			return this.topNode.addElement(current);
		}


	}
	else if ((current.nodeType=='OPEN') || (current.nodeType=='SINGLE')) {
		// if we find an element tag (open or empty)
		var success = false;

		// if the stack is empty, this node becomes the document node

		if(this.topNode==null) {
			this.docNode = current;
			current.parent = null;
			success = true;
		}
		else {
			// otherwise, append this as child to the element at the top of the stack
			success = this.topNode.addElement(current);
		}


		if (success && (current.nodeType!='SINGLE')) {
			this.topNode = current;
		}

		// rename it as an element node

		current.nodeType = "ELEMENT";

		return success;
	}

	// if it's a close tag, check the nesting

	else if (current.nodeType=='CLOSE') {

		// if the stack is empty, it's certainly an error

		if (this.topNode==null) {
			return this.error("close tag without open: " +	current.toString());
		}
		else {

			// otherwise, check that this node matches the one on the top of the stack

			if (current.tagName!=this.topNode.tagName) {
				return this.error("expected closing " + this.topNode.tagName + ", found closing " + current.tagName);
			}
			else {
				// if it does, pop the element off the top of the stack
				this.topNode = this.topNode.getParent();
			}
		}
	}
	return true;
} // end function _XMLDoc_handleNode



function _XMLDoc_insertNodeAfter (referenceNode, newNode) {
	/*******************************************************************************************************************
	function:	 _XMLDoc_insertNodeAfter

	Author: djoham@yahoo.com

	Description:
		inserts a new XML node after the reference node;

		for example, if we insert the node <tag2>hello</tag2>
		after tag1 in the xml <rootnode><tag1></tag1></rootnode>
		we will end up with <rootnode><tag1></tag1><tag2>hello</tag2></rootnode>

		NOTE: the return value of this function is a new XMLDoc object!!!!

	*********************************************************************************************************************/

	var parentXMLText = this.getUnderlyingXMLText();
	var selectedNodeXMLText = referenceNode.getUnderlyingXMLText();
	var originalNodePos = parentXMLText.indexOf(selectedNodeXMLText) + selectedNodeXMLText.length;
	var newXML = parentXMLText.substr(0,originalNodePos);
	newXML += newNode.getUnderlyingXMLText();
	newXML += parentXMLText.substr(originalNodePos);
	var newDoc = new XMLDoc(newXML, this.errFn);
	return newDoc;

} // end function _XMLDoc_insertNodeAfter



function _XMLDoc_insertNodeInto (referenceNode, insertNode) {
	/*******************************************************************************************************************
	function:	 _XMLDoc_insertNodeInto

	Author: mike@idle.org

	Description:
		inserts a new XML node into the reference node;

		for example, if we insert the node <tag2>hello</tag2>
		into tag1 in the xml <rootnode><tag1><tag3>foo</tag3></tag1></rootnode>
		we will end up with <rootnode><tag1><tag2>hello</tag2><tag3>foo</tag3></tag1></rootnode>

		NOTE: the return value of this function is a new XMLDoc object!!!!
	*********************************************************************************************************************/

	var parentXMLText = this.getUnderlyingXMLText();
	var selectedNodeXMLText = referenceNode.getUnderlyingXMLText();
	var endFirstTag = selectedNodeXMLText.indexOf(">") + 1;
	var originalNodePos = parentXMLText.indexOf(selectedNodeXMLText) + endFirstTag;
	var newXML = parentXMLText.substr(0,originalNodePos);
	newXML += insertNode.getUnderlyingXMLText();
	newXML += parentXMLText.substr(originalNodePos);
	var newDoc = new XMLDoc(newXML, this.errFn);
	return newDoc;


} // end function _XMLDoc_insertNodeInto

function _XMLDoc_loadXML(source){
	/*******************************************************************************************************************
	function:	 _XMLDoc_insertNodeInto

	Author: xwisdom@yahoo.com

	Description:
		allows an already existing XMLDoc object to load XML
	*********************************************************************************************************************/
	this.topNode=null;
	this.hasErrors = false;
	this.source=source;
	// parse the document
	return this.parse();

} // end function _XMLDoc_loadXML

function _XMLDoc_parse() {
	/*******************************************************************************************************************
	function:	 _XMLDoc_parse

	Author: mike@idle.org

	Description:
		scans through the source for opening and closing tags
		checks that the tags open and close in a sensible order
	*********************************************************************************************************************/

	var pos = 0;

	// set up the arrays used to store positions of < and > characters

	err = false;

	while(!err) {
		var closing_tag_prefix = '';
		var chpos = this.source.indexOf('<',pos);
		var open_length = 1;

		var open;
		var close;

		if (chpos ==-1) {
			break;
		}

		open = chpos;

		// create a text node

		var str = this.source.substring(pos, open);

		if (str.length!=0) {
			err = !this.handleNode(new XMLNode('TEXT',this, str));
		}

		// handle Programming Instructions - they can't reliably be handled as tags

		if (chpos == this.source.indexOf("<?",pos)) {
			pos = this.parsePI(this.source, pos + 2);
			if (pos==0) {
				err=true;
			}
			continue;
		}

		// nobble the document type definition

		if (chpos == this.source.indexOf("<!DOCTYPE",pos)) {
			pos = this.parseDTD(this.source, chpos+ 9);
			if (pos==0) {
				err=true;
			}
			continue;
		}

		// if we found an open comment, we need to ignore angle brackets
		// until we find a close comment

		if(chpos == this.source.indexOf('<!--',pos)) {
			open_length = 4;
			closing_tag_prefix = '--';
		}

		// similarly, if we find an open CDATA, we need to ignore all angle
		// brackets until a close CDATA sequence is found

		if (chpos == this.source.indexOf('<![CDATA[',pos)) {
			open_length = 9;
			closing_tag_prefix = ']]';
		}

		// look for the closing sequence

		chpos = this.source.indexOf(closing_tag_prefix + '>',chpos);
		if (chpos ==-1) {
			return this.error("expected closing tag sequence: " + closing_tag_prefix + '>');
		}

		close = chpos + closing_tag_prefix.length;

		// create a tag node

		str = this.source.substring(open+1, close);

		var n = this.parseTag(str);
		if (n) {
			err = !this.handleNode(n);
		}

		pos = close +1;

	// and loop

	}
	return !err;

} // end function _XMLDoc_parse



function _XMLDoc_parseAttribute(src,pos,node) {
	/*******************************************************************************************************************
	function:	 _XMLDoc_parseAttribute

	Author: mike@idle.org

	Description:
		parse an attribute out of a tag string

	*********************************************************************************************************************/

	// chew up the whitespace, if any

	while ((pos<src.length) && (whitespace.indexOf(src.charAt(pos))!=-1)) {
		pos++;
	}

	// if there's nothing else, we have no (more) attributes - just break out

	if (pos >= src.length) {
		return pos;
	}

	var p1 = pos;

	while ((pos < src.length) && (src.charAt(pos)!='=')) {
		pos++;
	}

	var msg = "attributes must have values";

	// parameters without values aren't allowed.

	if(pos >= src.length) {
		return this.error(msg);
	}

	// extract the parameter name

	var paramname = trim(src.substring(p1,pos++),false,true);

	// chew up whitespace

	while ((pos < src.length) && (whitespace.indexOf(src.charAt(pos))!=-1)) {
		pos++;
	}

	// throw an error if we've run out of string

	if (pos >= src.length) {
		return this.error(msg);
	}

	msg = "attribute values must be in quotes";

	// check for a quote mark to identify the beginning of the attribute value

	var quote = src.charAt(pos++);

	// throw an error if we didn't find one

	if (quotes.indexOf(quote)==-1) {
		return this.error(msg);
	}

	p1 = pos;

	while ((pos < src.length) && (src.charAt(pos)!=quote)) {
		pos++;
	}

	// throw an error if we found no closing quote

	if (pos >= src.length) {
		return this.error(msg);
	}

	// store the parameter

	if (!node.addAttribute(paramname,trim(src.substring(p1,pos++),false,true))) {
		return 0;
	}

	return pos;

}	//end function _XMLDoc_parseAttribute



function _XMLDoc_parseDTD(str,pos) {
	/*******************************************************************************************************************
	function:	 _XMLDoc_parseDTD

	Author: mike@idle.org

	Description:
		parse a document type declaration

		NOTE: we're just going to discard the DTD

	*********************************************************************************************************************/
	// we're just going to discard the DTD

	var firstClose = str.indexOf('>',pos);

	if (firstClose==-1) {
		return this.error("error in DTD: expected '>'");
	}

	var closing_tag_prefix = '';

	var firstOpenSquare = str.indexOf('[',pos);

	if ((firstOpenSquare!=-1) && (firstOpenSquare < firstClose)) {
		closing_tag_prefix = ']';
	}

	while(true) {
		var closepos = str.indexOf(closing_tag_prefix + '>',pos);

		if (closepos ==-1) {
			return this.error("expected closing tag sequence: " + closing_tag_prefix + '>');
		}

		pos = closepos + closing_tag_prefix.length +1;

		if (str.substring(closepos-1,closepos+2) != ']]>') {
			break;
		}
	}
	return pos;

} // end function _XMLDoc_ParseDTD


function _XMLDoc_parsePI(str,pos) {
	/*******************************************************************************************************************
	function:	 _XMLDoc_parsePI

	Author: mike@idle.org

	Description:
		parse a processing instruction

		NOTE: we just swallow them up at the moment

	*********************************************************************************************************************/
	// we just swallow them up

	var closepos = str.indexOf('?>',pos);
	return closepos + 2;

} // end function _XMLDoc_parsePI



function _XMLDoc_parseTag(src) {
	/*******************************************************************************************************************
	function:	 _XMLDoc_parseTag

	Author: mike@idle.org

	Description:
		parse out a non-text element (incl. CDATA, comments)
		handles the parsing of attributes
	*********************************************************************************************************************/

	// if it's a comment, strip off the packaging, mark it a comment node
	// and return it

	if (src.indexOf('!--')==0) {
		return new XMLNode('COMMENT', this, src.substring(3,src.length-2));
	}

	// if it's CDATA, do similar

	if (src.indexOf('![CDATA[')==0) {
		return new XMLNode('CDATA', this, src.substring(8,src.length-2));
	}

	var n = new XMLNode();
	n.doc = this;


	if (src.charAt(0)=='/') {
		n.nodeType = 'CLOSE';
		src = src.substring(1);
	}
	else {
		// otherwise it's an open tag (possibly an empty element)
		n.nodeType = 'OPEN';
	}

	// if the last character is a /, check it's not a CLOSE tag

	if (src.charAt(src.length-1)=='/') {
		if (n.nodeType=='CLOSE') {
			return this.error("singleton close tag");
		}
		else {
			n.nodeType = 'SINGLE';
		}

		// strip off the last character

		src = src.substring(0,src.length-1);
	}

	// set up the properties as appropriate

	if (n.nodeType!='CLOSE') {
		n.attributes = new Array();
	}

	if (n.nodeType=='OPEN') {
		n.children = new Array();
	}

	// trim the whitespace off the remaining content

	src = trim(src,true,true);

	// chuck out an error if there's nothing left

	if (src.length==0) {
		return this.error("empty tag");
	}

	// scan forward until a space...

	var endOfName = firstWhiteChar(src,0);

	// if there is no space, this is just a name (e.g. (<tag>, <tag/> or </tag>

	if (endOfName==-1) {
		n.tagName = src;
		return n;
	}

	// otherwise, we should expect attributes - but store the tag name first

	n.tagName = src.substring(0,endOfName);

	// start from after the tag name

	var pos = endOfName;

	// now we loop:

	while(pos< src.length) {
		pos = this.parseAttribute(src, pos, n);
		if (this.pos==0) {
			return null;
		}

		// and loop

	}
	return n;

} // end function _XMLDoc_parseTag



function _XMLDoc_removeNodeFromTree(node) {
	/*******************************************************************************************************************
	function:	 _XMLDoc_removeNodeFromTree

	Author: djoham@yahoo.com

	Description:
		removes the specified node from the tree

		NOTE: the return value of this function is a new XMLDoc object

	*********************************************************************************************************************/

	var parentXMLText = this.getUnderlyingXMLText();
	var selectedNodeXMLText = node.getUnderlyingXMLText();
	var originalNodePos = parentXMLText.indexOf(selectedNodeXMLText);
	var newXML = parentXMLText.substr(0,originalNodePos);
	newXML += parentXMLText.substr(originalNodePos + selectedNodeXMLText.length);
	var newDoc = new XMLDoc(newXML, this.errFn);
	return newDoc;
} // end function _XMLDoc_removeNodeFromTree



function _XMLDoc_replaceNodeContents(referenceNode, newContents) {
	/*******************************************************************************************************************
	function:	 _XMLDoc_replaceNodeContents

	Author: djoham@yahoo.com

	Description:

		make a node object out of the newContents text
		coming in ----

		The "X" node will be thrown away and only the children
		used to replace the contents of the reference node

		NOTE: the return value of this function is a new XMLDoc object

	*********************************************************************************************************************/

	var newNode = this.createXMLNode("<X>" + newContents + "</X>");
	referenceNode.children = newNode.children;
	return this;
} // end function _XMLDoc_replaceNodeContents


function _XMLDoc_selectNode(tagpath){
	/*******************************************************************************************************************
	function:	_XMLDoc_selectNode

	Author:		xwisdom@yahoo.com

	Description:
		selects a single node using the nodes tag path.
		examples: /node1/node2	or	/taga/tag1[0]/tag2
	*********************************************************************************************************************/

	tagpath = trim(tagpath, true, true);

	var srcnode,node,tag,params,elm,rg;
	var tags,attrName,attrValue,ok;
	srcnode=node=((this.source)?this.docNode:this);
	if (!tagpath) return node;
	if(tagpath.indexOf('/')==0)tagpath=tagpath.substr(1);
	tagpath=tagpath.replace(tag,'');
	tags=tagpath.split('/');
	tag=tags[0];
	if(tag){
		if(tagpath.indexOf('/')==0)tagpath=tagpath.substr(1);
		tagpath=tagpath.replace(tag,'');
		params=_XMLDoc_getTagNameParams(tag,this);
		tag=params[0];elm=params[1];
		attrName=params[2];attrValue=params[3];
		node=(tag=='*')? node.getElements():node.getElements(tag);
		if (node.length) {
			if(elm<0){
				srcnode=node;var i=0;
				while(i<srcnode.length){
					if(attrName){
						if (srcnode[i].getAttribute(attrName)!=attrValue) ok=false;
						else ok=true;
					}else ok=true;
					if(ok){
						node=srcnode[i].selectNode(tagpath);
						if(node) return node;
					}
					i++;
				}
			}else if (elm<node.length){
				node=node[elm].selectNode(tagpath);
				if(node) return node;
			}
		}
	}
} // end function _XMLDoc_selectNode

function _XMLDoc_selectNodeText(tagpath){
	/*******************************************************************************************************************
	function:	_XMLDoc_selectNodeText

	Author:		xwisdom@yahoo.com

	Description:
		selects a single node using the nodes tag path and then returns the node text.
	*********************************************************************************************************************/

	var node=this.selectNode(tagpath);
	if (node != null) {
		return node.getText();
	}
	else {
		return null;
	}
} // end function _XMLDoc_selectNodeText








// =========================================================================
// =========================================================================
// =========================================================================
// XML NODE FUNCTIONS
// =========================================================================
// =========================================================================
// =========================================================================


function XMLNode(nodeType,doc, str) {
	/*******************************************************************************************************************
	function: xmlNode

	Author: mike@idle.org

	Description:

		XMLNode() is a constructor for a node of XML (text, comment, cdata, tag, etc)

		nodeType = indicates the node type of the node
		doc == contains a reference to the XMLDoc object describing the document
		str == contains the text for the tag or text entity

	*********************************************************************************************************************/


	// the content of text (also CDATA and COMMENT) nodes
	if (nodeType=='TEXT' || nodeType=='CDATA' || nodeType=='COMMENT' ) {
		this.content = str;
	}
	else {
		this.content = null;
	}

	this.attributes = null; // an array of attributes (used as a hash table)
	this.children = null;	 // an array (list) of the children of this node
	this.doc = doc;		 // a reference to the document
	this.nodeType = nodeType;			// the type of the node
	this.parent = "";
	this.tagName = "";			 // the name of the tag (if a tag node)

	// configure the methods
	this.addAttribute = _XMLNode_addAttribute;
	this.addElement = _XMLNode_addElement;
	this.getAttribute = _XMLNode_getAttribute;
	this.getAttributeNames = _XMLNode_getAttributeNames;
	this.getElementById = _XMLNode_getElementById;
	this.getElements = _XMLNode_getElements;
	this.getText = _XMLNode_getText;
	this.getParent = _XMLNode_getParent;
	this.getUnderlyingXMLText = _XMLNode_getUnderlyingXMLText;
	this.removeAttribute = _XMLNode_removeAttribute;
	this.selectNode = _XMLDoc_selectNode;
	this.selectNodeText = _XMLDoc_selectNodeText;
	this.toString = _XMLNode_toString;

}	// end function XMLNode


function _XMLNode_addAttribute(attributeName,attributeValue) {
	/*******************************************************************************************************************
	function: _XMLNode_addAttribute

	Author: mike@idle.org

	Description:
		add an attribute to a node
	*********************************************************************************************************************/

	//if the name is found, the old value is overwritten by the new value
	this.attributes['_' + attributeName] = attributeValue;
	return true;

} // end function _XMLNode_addAttribute



function _XMLNode_addElement(node) {
	/*******************************************************************************************************************
	function: _XMLNode_addElement

	Author: mike@idle.org

	Description:
		add an element child to a node
	*********************************************************************************************************************/
	node.parent = this;
	this.children[this.children.length] = node;
	return true;

} // end function _XMLNode_addElement


function _XMLNode_getAttribute(name) {
	/*******************************************************************************************************************
	function: _XMLNode_getAttribute

	Author: mike@idle.org

	Description:
		get the value of a named attribute from an element node

		NOTE: we prefix with "_" because of the weird 'length' meta-property

	*********************************************************************************************************************/
	if (this.attributes == null) {
		return null;
	}
	return this.attributes['_' + name];
} // end function _XMLNode_getAttribute



function _XMLNode_getAttributeNames() {
	/*******************************************************************************************************************
	function: _XMLNode_getAttributeNames

	Author: mike@idle.org

	Description:
		get a list of attribute names for the node

		NOTE: we prefix with "_" because of the weird 'length' meta-property

		NOTE: Version 1.0 of getAttributeNames breaks backwards compatibility. Previous to 1.0
		getAttributeNames would return null if there were no attributes. 1.0 now returns an
		array of length 0.


	*********************************************************************************************************************/
	if (this.attributes == null) {
		var ret = new Array();
		return ret;
	}

	var attlist = new Array();

	for (var a in this.attributes) {
		attlist[attlist.length] = a.substring(1);
	}
	return attlist;
} // end function _XMLNode_getAttributeNames

function _XMLNode_getElementById(id) {

	/***********************************************************************************
	Function: getElementById

	Author: djoham@yahoo.com

	Description:
		Brute force searches through the XML DOM tree
		to find the node with the unique ID passed in

	************************************************************************************/
	var node = this;
	var ret;

	//alert("tag name=" + node.tagName);
	//alert("id=" + node.getAttribute("id"));
	if (node.getAttribute("id") == id) {
		return node;
	}
	else{
		var elements = node.getElements();
		//alert("length=" + rugrats.length);
		var intLoop = 0;
		//do NOT use a for loop here. For some reason
		//it kills some browsers!!!
		while (intLoop < elements.length) {
			//alert("intLoop=" + intLoop);
			var element = elements[intLoop];
			//alert("recursion");
			ret = element.getElementById(id);
			if (ret != null) {
				//alert("breaking");
				break;
			}
			intLoop++;
		}
	}
	return ret;
} // end function _XMLNode_getElementById


function _XMLNode_getElements(byName) {
	/*******************************************************************************************************************
	function:	 _XMLNode_getElements

	Author: mike@idle.org

	Description:
		get an array of element children of a node
		with an optional filter by name

		NOTE: Version 1.0 of getElements breaks backwards compatibility. Previous to 1.0
		getElements would return null if there were no attributes. 1.0 now returns an
		array of length 0.


	*********************************************************************************************************************/
	if (this.children==null) {
		var ret = new Array();
		return ret;
	}

	var elements = new Array();
	for (var i=0; i<this.children.length; i++) {
		if ((this.children[i].nodeType=='ELEMENT') && ((byName==null) || (this.children[i].tagName == byName))) {
			elements[elements.length] = this.children[i];
		}
	}
	return elements;
} // end function _XMLNode_getElements



function _XMLNode_getText() {
	/*******************************************************************************************************************
	function:		 _XMLNode_getText

	Author: mike@idle.org

	Description:
		a method to get the text of a given node (recursively, if it's an element)
	*********************************************************************************************************************/

	if (this.nodeType=='ELEMENT') {
		if (this.children==null) {
			return null;
		}
		var str = "";
		for (var i=0; i < this.children.length; i++) {
			var t = this.children[i].getText();
			str +=	(t == null ? "" : t);
		}
		return str;
	}
	else if (this.nodeType=='TEXT') {
		return convertEscapes(this.content);
	}
	else {
		return this.content;
	}
} // end function _XMLNode_getText



function _XMLNode_getParent() {
	/*******************************************************************************************************************
	function:		 _XMLNode_getParent

	Author: mike@idle.org

	Description:
		get the parent of this node
	*********************************************************************************************************************/
	return this.parent;

} // end function _XMLNode_getParent


function _XMLNode_getUnderlyingXMLText() {
	/*******************************************************************************************************************
	function:		 David Joham

	Author: djoham@yahoo.com

	Description:
		returns the underlying XML text for the node
		by calling the _displayElement function
	*********************************************************************************************************************/

	var strRet = "";
	strRet = _displayElement(this, strRet);
	return strRet;

} // end function _XMLNode_getUnderlyingXMLText



function _XMLNode_removeAttribute(attributeName) {
	/*******************************************************************************************************************
	function:		 _XMLNode_removeAttribute

	Author: djoham@yahoo.com

	Description:
		remove an attribute from a node
	*********************************************************************************************************************/
	if(attributeName == null) {
		return this.doc.error("You must pass an attribute name into the removeAttribute function");
	}

	//now remove the attribute from the list.
	// I want to keep the logic for adding attribtues in one place. I'm
	// going to get a temp array of attributes and values here and then
	// use the addAttribute function to re-add the attributes
	var attributes = this.getAttributeNames();
	var intCount = attributes.length;
	var tmpAttributeValues = new Array();
	for ( intLoop = 0; intLoop < intCount; intLoop++) {
		tmpAttributeValues[intLoop] = this.getAttribute(attributes[intLoop]);
	}

	// now blow away the old attribute list
	this.attributes = new Array();

	//now add the attributes back to the array - leaving out the one we're removing
	for (intLoop = 0; intLoop < intCount; intLoop++) {
		if ( attributes[intLoop] != attributeName) {
			this.addAttribute(attributes[intLoop], tmpAttributeValues[intLoop]);
		}
	}

return true;

} // end function _XMLNode_removeAttribute



function _XMLNode_toString() {
	/*******************************************************************************************************************
	function:		 _XMLNode_toString

	Author: mike@idle.org

	Description:
		produces a diagnostic string description of a node
	*********************************************************************************************************************/
	return "" + this.nodeType + ":" + (this.nodeType=='TEXT' || this.nodeType=='CDATA' || this.nodeType=='COMMENT' ? this.content : this.tagName);

} // end function _XMLNode_toString


























// =========================================================================
//
// xmlw3cdom.js - a W3C compliant DOM parser for XML for <SCRIPT>
//
// version 3.1
//
// =========================================================================
//
// Copyright (C) 2002, 2003, 2004 Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.

// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
// Lesser General Public License for more details.

// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA	02111-1307	USA
//
// visit the XML for <SCRIPT> home page at xmljs.sourceforge.net
//
// Contains text (used within comments to methods) from the
//	XML Path Language (XPath) Version 1.0 W3C Recommendation
//	Copyright � 16 November 1999 World Wide Web Consortium,
//	(Massachusetts Institute of Technology,
//	European Research Consortium for Informatics and Mathematics, Keio University).
//	All Rights Reserved.
//	(see: http://www.w3.org/TR/2000/WD-DOM-Level-1-20000929/)

/**
 * @function addClass - add new className to classCollection
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	classCollectionStr : string - list of existing class names
 *	 (separated and top and tailed with '|'s)
 * @param	newClass			 : string - new class name to add
 *
 * @return : string - the new classCollection, with new className appended,
 *	 (separated and top and tailed with '|'s)
 */
function addClass(classCollectionStr, newClass) {
	if (classCollectionStr) {
	if (classCollectionStr.indexOf("|"+ newClass +"|") < 0) {
		classCollectionStr += newClass + "|";
	}
	}
	else {
	classCollectionStr = "|"+ newClass + "|";
	}

	return classCollectionStr;
}

/**
 * @class	DOMException - raised when an operation is impossible to perform
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	code : int - the exception code (one of the DOMException constants)
 */
DOMException = function(code) {
	this._class = addClass(this._class, "DOMException");

	this.code = code;
};

// DOMException constants
// Introduced in DOM Level 1:
DOMException.INDEX_SIZE_ERR				 = 1;
DOMException.DOMSTRING_SIZE_ERR			 = 2;
DOMException.HIERARCHY_REQUEST_ERR			= 3;
DOMException.WRONG_DOCUMENT_ERR			 = 4;
DOMException.INVALID_CHARACTER_ERR			= 5;
DOMException.NO_DATA_ALLOWED_ERR			= 6;
DOMException.NO_MODIFICATION_ALLOWED_ERR	= 7;
DOMException.NOT_FOUND_ERR					= 8;
DOMException.NOT_SUPPORTED_ERR				= 9;
DOMException.INUSE_ATTRIBUTE_ERR			= 10;

// Introduced in DOM Level 2:
DOMException.INVALID_STATE_ERR				= 11;
DOMException.SYNTAX_ERR					 = 12;
DOMException.INVALID_MODIFICATION_ERR		 = 13;
DOMException.NAMESPACE_ERR					= 14;
DOMException.INVALID_ACCESS_ERR			 = 15;


/**
 * @class	DOMImplementation - provides a number of methods for performing operations
 *	 that are independent of any particular instance of the document object model.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 */
DOMImplementation = function() {
	this._class = addClass(this._class, "DOMImplementation");
	this._p = null;

	this.preserveWhiteSpace = false;	// by default, ignore whitespace
	this.namespaceAware = true;		 // by default, handle namespaces
	this.errorChecking	= true;		 // by default, test for exceptions
};


/**
 * @method DOMImplementation.escapeString - escape special characters
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	str : string - The string to be escaped
 *
 * @return : string - The escaped string
 */
DOMImplementation.prototype.escapeString = function DOMNode__escapeString(str) {

	//the sax processor already has this function. Just wrap it
	return __escapeString(str);
};

/**
 * @method DOMImplementation.unescapeString - unescape special characters
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	str : string - The string to be unescaped
 *
 * @return : string - The unescaped string
 */
DOMImplementation.prototype.unescapeString = function DOMNode__unescapeString(str) {

	//the sax processor already has this function. Just wrap it
	return __unescapeString(str);
};

/**
 * @method DOMImplementation.hasFeature - Test if the DOM implementation implements a specific feature
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	feature : string - The package name of the feature to test. the legal only values are "XML" and "CORE" (case-insensitive).
 * @param	version : string - This is the version number of the package name to test. In Level 1, this is the string "1.0".
 *
 * @return : boolean
 */
DOMImplementation.prototype.hasFeature = function DOMImplementation_hasFeature(feature, version) {

	var ret = false;
	if (feature.toLowerCase() == "xml") {
	ret = (!version || (version == "1.0") || (version == "2.0"));
	}
	else if (feature.toLowerCase() == "core") {
	ret = (!version || (version == "2.0"));
	}

	return ret;
};

/**
 * @method DOMImplementation.loadXML - parse XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 *
 * @param	xmlStr : string - the XML string
 *
 * @return : DOMDocument
 */
DOMImplementation.prototype.loadXML = function DOMImplementation_loadXML(xmlStr) {
	// create SAX Parser
	var parser;

	try {
	parser = new XMLP(xmlStr);
	}
	catch (e) {
	alert("Error Creating the SAX Parser. Did you include xmlsax.js or tinyxmlsax.js in your web page?\nThe SAX parser is needed to populate XML for <SCRIPT>'s W3C DOM Parser with data.");
	}

	// create DOM Document
	var doc = new DOMDocument(this);

	// populate Document with Parsed Nodes
	this._parseLoop(doc, parser);

	// set parseComplete flag, (Some validation Rules are relaxed if this is false)
	doc._parseComplete = true;

	return doc;
};


/**
 * @method DOMImplementation.translateErrCode - convert DOMException Code
 *	 to human readable error message;
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	code : int - the DOMException code
 *
 * @return : string - the human readbale error message
 */
DOMImplementation.prototype.translateErrCode = function DOMImplementation_translateErrCode(code) {
	var msg = "";

	switch (code) {
	case DOMException.INDEX_SIZE_ERR :				// 1
		 msg = "INDEX_SIZE_ERR: Index out of bounds";
		 break;

	case DOMException.DOMSTRING_SIZE_ERR :			// 2
		 msg = "DOMSTRING_SIZE_ERR: The resulting string is too long to fit in a DOMString";
		 break;

	case DOMException.HIERARCHY_REQUEST_ERR :		 // 3
		 msg = "HIERARCHY_REQUEST_ERR: The Node can not be inserted at this location";
		 break;

	case DOMException.WRONG_DOCUMENT_ERR :			// 4
		 msg = "WRONG_DOCUMENT_ERR: The source and the destination Documents are not the same";
		 break;

	case DOMException.INVALID_CHARACTER_ERR :		 // 5
		 msg = "INVALID_CHARACTER_ERR: The string contains an invalid character";
		 break;

	case DOMException.NO_DATA_ALLOWED_ERR :			 // 6
		 msg = "NO_DATA_ALLOWED_ERR: This Node / NodeList does not support data";
		 break;

	case DOMException.NO_MODIFICATION_ALLOWED_ERR :	 // 7
		 msg = "NO_MODIFICATION_ALLOWED_ERR: This object cannot be modified";
		 break;

	case DOMException.NOT_FOUND_ERR :				 // 8
		 msg = "NOT_FOUND_ERR: The item cannot be found";
		 break;

	case DOMException.NOT_SUPPORTED_ERR :			 // 9
		 msg = "NOT_SUPPORTED_ERR: This implementation does not support function";
		 break;

	case DOMException.INUSE_ATTRIBUTE_ERR :			 // 10
		 msg = "INUSE_ATTRIBUTE_ERR: The Attribute has already been assigned to another Element";
		 break;

// Introduced in DOM Level 2:
	case DOMException.INVALID_STATE_ERR :			 // 11
		 msg = "INVALID_STATE_ERR: The object is no longer usable";
		 break;

	case DOMException.SYNTAX_ERR :					// 12
		 msg = "SYNTAX_ERR: Syntax error";
		 break;

	case DOMException.INVALID_MODIFICATION_ERR :		// 13
		 msg = "INVALID_MODIFICATION_ERR: Cannot change the type of the object";
		 break;

	case DOMException.NAMESPACE_ERR :				 // 14
		 msg = "NAMESPACE_ERR: The namespace declaration is incorrect";
		 break;

	case DOMException.INVALID_ACCESS_ERR :			// 15
		 msg = "INVALID_ACCESS_ERR: The object does not support this function";
		 break;

	default :
		 msg = "UNKNOWN: Unknown Exception Code ("+ code +")";
	}

	return msg;
}

/**
 * @method DOMImplementation._parseLoop - process SAX events
 *
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 *
 * @param	doc : DOMDocument - the Document to contain the parsed XML string
 * @param	p	 : XMLP		- the SAX Parser
 *
 * @return : DOMDocument
 */
DOMImplementation.prototype._parseLoop = function DOMImplementation__parseLoop(doc, p) {
	var iEvt, iNode, iAttr, strName;
	iNodeParent = doc;

	var el_close_count = 0;

	var entitiesList = new Array();
	var textNodesList = new Array();

	// if namespaceAware, add default namespace
	if (this.namespaceAware) {
	var iNS = doc.createNamespace(""); // add the default-default namespace
	iNS.setValue("http://www.w3.org/2000/xmlns/");
	doc._namespaces.setNamedItem(iNS);
	}

	// loop until SAX parser stops emitting events
	while(true) {
	// get next event
	iEvt = p.next();

	if (iEvt == XMLP._ELM_B) {						// Begin-Element Event
		var pName = p.getName();						// get the Element name
		pName = trim(pName, true, true);				// strip spaces from Element name

		if (!this.namespaceAware) {
		iNode = doc.createElement(p.getName());	 // create the Element

		// add attributes to Element
		for(var i = 0; i < p.getAttributeCount(); i++) {
			strName = p.getAttributeName(i);			// get Attribute name
			iAttr = iNode.getAttributeNode(strName);	// if Attribute exists, use it

			if(!iAttr) {
			iAttr = doc.createAttribute(strName);	 // otherwise create it
			}

			iAttr.setValue(p.getAttributeValue(i));	 // set Attribute value
			iNode.setAttributeNode(iAttr);			// attach Attribute to Element
		}
		}
		else {	// Namespace Aware
		// create element (with empty namespaceURI,
		//	resolve after namespace 'attributes' have been parsed)
		iNode = doc.createElementNS("", p.getName());

		// duplicate ParentNode's Namespace definitions
		iNode._namespaces = iNodeParent._namespaces._cloneNodes(iNode);

		// add attributes to Element
		for(var i = 0; i < p.getAttributeCount(); i++) {
			strName = p.getAttributeName(i);			// get Attribute name

			// if attribute is a namespace declaration
			if (this._isNamespaceDeclaration(strName)) {
			// parse Namespace Declaration
			var namespaceDec = this._parseNSName(strName);

			if (strName != "xmlns") {
				iNS = doc.createNamespace(strName);	 // define namespace
			}
			else {
				iNS = doc.createNamespace("");		// redefine default namespace
			}
			iNS.setValue(p.getAttributeValue(i));	 // set value = namespaceURI

			iNode._namespaces.setNamedItem(iNS);	// attach namespace to namespace collection
			}
			else {	// otherwise, it is a normal attribute
			iAttr = iNode.getAttributeNode(strName);		// if Attribute exists, use it

			if(!iAttr) {
				iAttr = doc.createAttributeNS("", strName);	 // otherwise create it
			}

			iAttr.setValue(p.getAttributeValue(i));		 // set Attribute value
			iNode.setAttributeNodeNS(iAttr);				// attach Attribute to Element

			if (this._isIdDeclaration(strName)) {
				iNode.id = p.getAttributeValue(i);	// cache ID for getElementById()
			}
			}
		}

		// resolve namespaceURIs for this Element
		if (iNode._namespaces.getNamedItem(iNode.prefix)) {
			iNode.namespaceURI = iNode._namespaces.getNamedItem(iNode.prefix).value;
		}

		//	for this Element's attributes
		for (var i = 0; i < iNode.attributes.length; i++) {
			if (iNode.attributes.item(i).prefix != "") {	// attributes do not have a default namespace
			if (iNode._namespaces.getNamedItem(iNode.attributes.item(i).prefix)) {
				iNode.attributes.item(i).namespaceURI = iNode._namespaces.getNamedItem(iNode.attributes.item(i).prefix).value;
			}
			}
		}
		}

		// if this is the Root Element
		if (iNodeParent.nodeType == DOMNode.DOCUMENT_NODE) {
		iNodeParent.documentElement = iNode;		// register this Element as the Document.documentElement
		}

		iNodeParent.appendChild(iNode);				 // attach Element to parentNode
		iNodeParent = iNode;							// descend one level of the DOM Tree
	}

	else if(iEvt == XMLP._ELM_E) {					// End-Element Event
		iNodeParent = iNodeParent.parentNode;		 // ascend one level of the DOM Tree
	}

	else if(iEvt == XMLP._ELM_EMP) {				// Empty Element Event
		pName = p.getName();							// get the Element name
		pName = trim(pName, true, true);				// strip spaces from Element name

		if (!this.namespaceAware) {
		iNode = doc.createElement(pName);			 // create the Element

		// add attributes to Element
		for(var i = 0; i < p.getAttributeCount(); i++) {
			strName = p.getAttributeName(i);			// get Attribute name
			iAttr = iNode.getAttributeNode(strName);	// if Attribute exists, use it

			if(!iAttr) {
			iAttr = doc.createAttribute(strName);	 // otherwise create it
			}

			iAttr.setValue(p.getAttributeValue(i));	 // set Attribute value
			iNode.setAttributeNode(iAttr);			// attach Attribute to Element
		}
		}
		else {	// Namespace Aware
		// create element (with empty namespaceURI,
		//	resolve after namespace 'attributes' have been parsed)
		iNode = doc.createElementNS("", p.getName());

		// duplicate ParentNode's Namespace definitions
		iNode._namespaces = iNodeParent._namespaces._cloneNodes(iNode);

		// add attributes to Element
		for(var i = 0; i < p.getAttributeCount(); i++) {
			strName = p.getAttributeName(i);			// get Attribute name

			// if attribute is a namespace declaration
			if (this._isNamespaceDeclaration(strName)) {
			// parse Namespace Declaration
			var namespaceDec = this._parseNSName(strName);

			if (strName != "xmlns") {
				iNS = doc.createNamespace(strName);	 // define namespace
			}
			else {
				iNS = doc.createNamespace("");		// redefine default namespace
			}
			iNS.setValue(p.getAttributeValue(i));	 // set value = namespaceURI

			iNode._namespaces.setNamedItem(iNS);	// attach namespace to namespace collection
			}
			else {	// otherwise, it is a normal attribute
			iAttr = iNode.getAttributeNode(strName);		// if Attribute exists, use it

			if(!iAttr) {
				iAttr = doc.createAttributeNS("", strName);	 // otherwise create it
			}

			iAttr.setValue(p.getAttributeValue(i));		 // set Attribute value
			iNode.setAttributeNodeNS(iAttr);				// attach Attribute to Element

			if (this._isIdDeclaration(strName)) {
				iNode.id = p.getAttributeValue(i);	// cache ID for getElementById()
			}
			}
		}

		// resolve namespaceURIs for this Element
		if (iNode._namespaces.getNamedItem(iNode.prefix)) {
			iNode.namespaceURI = iNode._namespaces.getNamedItem(iNode.prefix).value;
		}

		//	for this Element's attributes
		for (var i = 0; i < iNode.attributes.length; i++) {
			if (iNode.attributes.item(i).prefix != "") {	// attributes do not have a default namespace
			if (iNode._namespaces.getNamedItem(iNode.attributes.item(i).prefix)) {
				iNode.attributes.item(i).namespaceURI = iNode._namespaces.getNamedItem(iNode.attributes.item(i).prefix).value;
			}
			}
		}
		}

		// if this is the Root Element
		if (iNodeParent.nodeType == DOMNode.DOCUMENT_NODE) {
		iNodeParent.documentElement = iNode;		// register this Element as the Document.documentElement
		}

		iNodeParent.appendChild(iNode);				 // attach Element to parentNode
	}
	else if(iEvt == XMLP._TEXT || iEvt == XMLP._ENTITY) {					 // TextNode and entity Events
		// get Text content
		var pContent = p.getContent().substring(p.getContentBegin(), p.getContentEnd());

		if (!this.preserveWhiteSpace ) {
		if (trim(pContent, true, true) == "") {
			pContent = ""; //this will cause us not to create the text node below
		}
		}

		if (pContent.length > 0) {					// ignore empty TextNodes
		var textNode = doc.createTextNode(pContent);
		iNodeParent.appendChild(textNode); // attach TextNode to parentNode

		//the sax parser breaks up text nodes when it finds an entity. For
		//example hello&lt;there will fire a text, an entity and another text
		//this sucks for the dom parser because it looks to us in this logic
		//as three text nodes. I fix this by keeping track of the entity nodes
		//and when we're done parsing, calling normalize on their parent to
		//turn the multiple text nodes into one, which is what DOM users expect
		//the code to do this is at the bottom of this function
		if (iEvt == XMLP._ENTITY) {
			entitiesList[entitiesList.length] = textNode;
		}
		else {
			//I can't properly decide how to handle preserve whitespace
			//until the siblings of the text node are built due to 
			//the entitiy handling described above. I don't know that this
			//will be all of the text node or not, so trimming is not appropriate
			//at this time. Keep a list of all the text nodes for now
			//and we'll process the preserve whitespace stuff at a later time.
			textNodesList[textNodesList.length] = textNode;
		}
		}
	}
	else if(iEvt == XMLP._PI) {					 // ProcessingInstruction Event
		// attach ProcessingInstruction to parentNode
		iNodeParent.appendChild(doc.createProcessingInstruction(p.getName(), p.getContent().substring(p.getContentBegin(), p.getContentEnd())));
	}
	else if(iEvt == XMLP._CDATA) {					// CDATA Event
		// get CDATA data
		pContent = p.getContent().substring(p.getContentBegin(), p.getContentEnd());

		if (!this.preserveWhiteSpace) {
		pContent = trim(pContent, true, true);		// trim whitespace
		pContent.replace(/ +/g, ' ');				 // collapse multiple spaces to 1 space
		}

		if (pContent.length > 0) {					// ignore empty CDATANodes
		iNodeParent.appendChild(doc.createCDATASection(pContent)); // attach CDATA to parentNode
		}
	}
	else if(iEvt == XMLP._COMMENT) {				// Comment Event
		// get COMMENT data
		var pContent = p.getContent().substring(p.getContentBegin(), p.getContentEnd());

		if (!this.preserveWhiteSpace) {
		pContent = trim(pContent, true, true);		// trim whitespace
		pContent.replace(/ +/g, ' ');				 // collapse multiple spaces to 1 space
		}

		if (pContent.length > 0) {					// ignore empty CommentNodes
		iNodeParent.appendChild(doc.createComment(pContent));	// attach Comment to parentNode
		}
	}
	else if(iEvt == XMLP._DTD) {					// ignore DTD events
	}
	else if(iEvt == XMLP._ERROR) {
		throw(new DOMException(DOMException.SYNTAX_ERR));
		// alert("Fatal Error: " + p.getContent() + "\nLine: " + p.getLineNumber() + "\nColumn: " + p.getColumnNumber() + "\n");
		// break;
	}
	else if(iEvt == XMLP._NONE) {					 // no more events
		if (iNodeParent == doc) {					 // confirm that we have recursed back up to root
		break;
		}
		else {
		throw(new DOMException(DOMException.SYNTAX_ERR));	// one or more Tags were not closed properly
		}
	}
	}

	//normalize any entities in the DOM to a single textNode
	var intCount = entitiesList.length;
	for (intLoop = 0; intLoop < intCount; intLoop++) {
		var entity = entitiesList[intLoop];
		//its possible (if for example two entities were in the
		//same domnode, that the normalize on the first entitiy
		//will remove the parent for the second. Only do normalize
		//if I can find a parent node
		var parentNode = entity.getParentNode();
		if (parentNode) {
			parentNode.normalize();

			//now do whitespace (if necessary)
			//it was not done for text nodes that have entities
			if(!this.preserveWhiteSpace) {
					var children = parentNode.getChildNodes();
				var intCount2 = children.getLength();
				for ( intLoop2 = 0; intLoop2 < intCount2; intLoop2++) {
					var child = children.item(intLoop2);
					if (child.getNodeType() == DOMNode.TEXT_NODE) {
						var childData = child.getData();
						childData = trim(childData, true, true);
						childData.replace(/ +/g, ' ');
						child.setData(childData);
					}
				}
			}
		}
	}

	//do the preserve whitespace processing on the rest of the text nodes
	//It's possible (due to the processing above) that the node will have been
	//removed from the tree. Only do whitespace checking if parentNode is not null.
	//This may duplicate the whitespace processing for some nodes that had entities in them
	//but there's no way around that
	if (!this.preserveWhiteSpace) {
		var intCount = textNodesList.length;
	for (intLoop = 0; intLoop < intCount; intLoop++) {
		var node = textNodesList[intLoop];
		if (node.getParentNode() != null) {
			var nodeData = node.getData();
			nodeData = trim(nodeData, true, true);
			nodeData.replace(/ +/g, ' ');
			node.setData(nodeData);
		}
	}

	}
};

/**
 * @method DOMImplementation._isNamespaceDeclaration - Return true, if attributeName is a namespace declaration
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	attributeName : string - the attribute name
 *
 * @return : boolean
 */
DOMImplementation.prototype._isNamespaceDeclaration = function DOMImplementation__isNamespaceDeclaration(attributeName) {
	// test if attributeName is 'xmlns'
	return (attributeName.indexOf('xmlns') > -1);
}

/**
 * @method DOMImplementation._isIdDeclaration - Return true, if attributeName is an id declaration
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	attributeName : string - the attribute name
 *
 * @return : boolean
 */
DOMImplementation.prototype._isIdDeclaration = function DOMImplementation__isIdDeclaration(attributeName) {
	// test if attributeName is 'id' (case insensitive)
	return (attributeName.toLowerCase() == 'id');
}

/**
 * @method DOMImplementation._isValidName - Return true,
 *	 if name contains no invalid characters
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	name : string - the candidate name
 *
 * @return : boolean
 */
DOMImplementation.prototype._isValidName = function DOMImplementation__isValidName(name) {
	// test if name contains only valid characters
	return name.match(re_validName);
}
re_validName = /^[a-zA-Z_:][a-zA-Z0-9\.\-_:]*$/;

/**
 * @method DOMImplementation._isValidString - Return true, if string does not contain any illegal chars
 *	All of the characters 0 through 31 and character 127 are nonprinting control characters.
 *	With the exception of characters 09, 10, and 13, (Ox09, Ox0A, and Ox0D)
 *	Note: different from _isValidName in that ValidStrings may contain spaces
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	name : string - the candidate string
 *
 * @return : boolean
 */
DOMImplementation.prototype._isValidString = function DOMImplementation__isValidString(name) {
	// test that string does not contains invalid characters
	return (name.search(re_invalidStringChars) < 0);
}
re_invalidStringChars = /\x01|\x02|\x03|\x04|\x05|\x06|\x07|\x08|\x0B|\x0C|\x0E|\x0F|\x10|\x11|\x12|\x13|\x14|\x15|\x16|\x17|\x18|\x19|\x1A|\x1B|\x1C|\x1D|\x1E|\x1F|\x7F/;

/**
 * @method DOMImplementation._parseNSName - parse the namespace name.
 *	if there is no colon, the
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	qualifiedName : string - The qualified name
 *
 * @return : NSName - [
 *					 .prefix		: string - The prefix part of the qname
 *					 .namespaceName : string - The namespaceURI part of the qname
 *					]
 */
DOMImplementation.prototype._parseNSName = function DOMImplementation__parseNSName(qualifiedName) {
	var resultNSName = new Object();

	resultNSName.prefix			= qualifiedName;	// unless the qname has a namespaceName, the prefix is the entire String
	resultNSName.namespaceName	 = "";

	// split on ':'
	delimPos = qualifiedName.indexOf(':');

	if (delimPos > -1) {
	// get prefix
	resultNSName.prefix		= qualifiedName.substring(0, delimPos);

	// get namespaceName
	resultNSName.namespaceName = qualifiedName.substring(delimPos +1, qualifiedName.length);
	}

	return resultNSName;
}

/**
 * @method DOMImplementation._parseQName - parse the qualified name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	qualifiedName : string - The qualified name
 *
 * @return : QName
 */
DOMImplementation.prototype._parseQName = function DOMImplementation__parseQName(qualifiedName) {
	var resultQName = new Object();

	resultQName.localName = qualifiedName;	// unless the qname has a prefix, the local name is the entire String
	resultQName.prefix	= "";

	// split on ':'
	delimPos = qualifiedName.indexOf(':');

	if (delimPos > -1) {
	// get prefix
	resultQName.prefix	= qualifiedName.substring(0, delimPos);

	// get localName
	resultQName.localName = qualifiedName.substring(delimPos +1, qualifiedName.length);
	}

	return resultQName;
}

/**
 * @class	DOMNodeList - provides the abstraction of an ordered collection of nodes
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	ownerDocument : DOMDocument - the ownerDocument
 * @param	parentNode	: DOMNode - the node that the DOMNodeList is attached to (or null)
 */
DOMNodeList = function(ownerDocument, parentNode) {
	this._class = addClass(this._class, "DOMNodeList");
	this._nodes = new Array();

	this.length = 0;
	this.parentNode = parentNode;
	this.ownerDocument = ownerDocument;

	this._readonly = false;
};

/**
 * @method DOMNodeList.getLength - Java style gettor for .length
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : int
 */
DOMNodeList.prototype.getLength = function DOMNodeList_getLength() {
	return this.length;
};

/**
 * @method DOMNodeList.item - Returns the indexth item in the collection.
 *	 If index is greater than or equal to the number of nodes in the list, this returns null.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	index : int - Index into the collection.
 *
 * @return : DOMNode - The node at the indexth position in the NodeList, or null if that is not a valid index
 */
DOMNodeList.prototype.item = function DOMNodeList_item(index) {
	var ret = null;

	if ((index >= 0) && (index < this._nodes.length)) { // bounds check
	ret = this._nodes[index];					// return selected Node
	}

	return ret;									// if the index is out of bounds, default value null is returned
};

/**
 * @method DOMNodeList._findItemIndex - find the item index of the node with the specified internal id
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	id : int - unique internal id
 *
 * @return : int
 */
DOMNodeList.prototype._findItemIndex = function DOMNodeList__findItemIndex(id) {
	var ret = -1;

	// test that id is valid
	if (id > -1) {
	for (var i=0; i<this._nodes.length; i++) {
		// compare id to each node's _id
		if (this._nodes[i]._id == id) {			// found it!
		ret = i;
		break;
		}
	}
	}

	return ret;									// if node is not found, default value -1 is returned
};

/**
 * @method DOMNodeList._insertBefore - insert the specified Node into the NodeList before the specified index
 *	 Used by DOMNode.insertBefore(). Note: DOMNode.insertBefore() is responsible for Node Pointer surgery
 *	 DOMNodeList._insertBefore() simply modifies the internal data structure (Array).
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	newChild		: DOMNode - the Node to be inserted
 * @param	refChildIndex : int	 - the array index to insert the Node before
 */
DOMNodeList.prototype._insertBefore = function DOMNodeList__insertBefore(newChild, refChildIndex) {
	if ((refChildIndex >= 0) && (refChildIndex < this._nodes.length)) { // bounds check
	// get array containing children prior to refChild
	var tmpArr = new Array();
	tmpArr = this._nodes.slice(0, refChildIndex);

	if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {	// node is a DocumentFragment
		// append the children of DocumentFragment
		tmpArr = tmpArr.concat(newChild.childNodes._nodes);
	}
	else {
		// append the newChild
		tmpArr[tmpArr.length] = newChild;
	}

	// append the remaining original children (including refChild)
	this._nodes = tmpArr.concat(this._nodes.slice(refChildIndex));

	this.length = this._nodes.length;			// update length
	}
};

/**
 * @method DOMNodeList._replaceChild - replace the specified Node in the NodeList at the specified index
 *	 Used by DOMNode.replaceChild(). Note: DOMNode.replaceChild() is responsible for Node Pointer surgery
 *	 DOMNodeList._replaceChild() simply modifies the internal data structure (Array).
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	newChild		: DOMNode - the Node to be inserted
 * @param	refChildIndex : int	 - the array index to hold the Node
 */
DOMNodeList.prototype._replaceChild = function DOMNodeList__replaceChild(newChild, refChildIndex) {
	var ret = null;

	if ((refChildIndex >= 0) && (refChildIndex < this._nodes.length)) { // bounds check
	ret = this._nodes[refChildIndex];			// preserve old child for return

	if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {	// node is a DocumentFragment
		// get array containing children prior to refChild
		var tmpArr = new Array();
		tmpArr = this._nodes.slice(0, refChildIndex);

		// append the children of DocumentFragment
		tmpArr = tmpArr.concat(newChild.childNodes._nodes);

		// append the remaining original children (not including refChild)
		this._nodes = tmpArr.concat(this._nodes.slice(refChildIndex + 1));
	}
	else {
		// simply replace node in array (links between Nodes are made at higher level)
		this._nodes[refChildIndex] = newChild;
	}
	}

	return ret;									 // return replaced node
};

/**
 * @method DOMNodeList._removeChild - remove the specified Node in the NodeList at the specified index
 *	 Used by DOMNode.removeChild(). Note: DOMNode.removeChild() is responsible for Node Pointer surgery
 *	 DOMNodeList._replaceChild() simply modifies the internal data structure (Array).
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	refChildIndex : int - the array index holding the Node to be removed
 */
DOMNodeList.prototype._removeChild = function DOMNodeList__removeChild(refChildIndex) {
	var ret = null;

	if (refChildIndex > -1) {								// found it!
	ret = this._nodes[refChildIndex];					// return removed node

	// rebuild array without removed child
	var tmpArr = new Array();
	tmpArr = this._nodes.slice(0, refChildIndex);
	this._nodes = tmpArr.concat(this._nodes.slice(refChildIndex +1));

	this.length = this._nodes.length;			// update length
	}

	return ret;									 // return removed node
};

/**
 * @method DOMNodeList._appendChild - append the specified Node to the NodeList
 *	 Used by DOMNode.appendChild(). Note: DOMNode.appendChild() is responsible for Node Pointer surgery
 *	 DOMNodeList._appendChild() simply modifies the internal data structure (Array).
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	newChild		: DOMNode - the Node to be inserted
 */
DOMNodeList.prototype._appendChild = function DOMNodeList__appendChild(newChild) {

	if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {	// node is a DocumentFragment
	// append the children of DocumentFragment
	this._nodes = this._nodes.concat(newChild.childNodes._nodes);
	}
	else {
	// simply add node to array (links between Nodes are made at higher level)
	this._nodes[this._nodes.length] = newChild;
	}

	this.length = this._nodes.length;				// update length
};

/**
 * @method DOMNodeList._cloneNodes - Returns a NodeList containing clones of the Nodes in this NodeList
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	deep : boolean - If true, recursively clone the subtree under each of the nodes;
 *	 if false, clone only the nodes themselves (and their attributes, if it is an Element).
 * @param	parentNode : DOMNode - the new parent of the cloned NodeList
 *
 * @return : DOMNodeList - NodeList containing clones of the Nodes in this NodeList
 */
DOMNodeList.prototype._cloneNodes = function DOMNodeList__cloneNodes(deep, parentNode) {
	var cloneNodeList = new DOMNodeList(this.ownerDocument, parentNode);

	// create list containing clones of each child
	for (var i=0; i < this._nodes.length; i++) {
	cloneNodeList._appendChild(this._nodes[i].cloneNode(deep));
	}

	return cloneNodeList;
};

/**
 * @method DOMNodeList.toString - Serialize this NodeList into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMNodeList.prototype.toString = function DOMNodeList_toString() {
	var ret = "";

	// create string containing the concatenation of the string values of each child
	for (var i=0; i < this.length; i++) {
	ret += this._nodes[i].toString();
	}

	return ret;
};

/**
 * @class	DOMNamedNodeMap - used to represent collections of nodes that can be accessed by name
 *	typically a set of Element attributes
 *
 * @extends DOMNodeList - note W3C spec says that this is not the case,
 *	 but we need an item() method identicle to DOMNodeList's, so why not?
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	ownerDocument : DOMDocument - the ownerDocument
 * @param	parentNode	: DOMNode - the node that the DOMNamedNodeMap is attached to (or null)
 */
DOMNamedNodeMap = function(ownerDocument, parentNode) {
	this._class = addClass(this._class, "DOMNamedNodeMap");
	this.DOMNodeList = DOMNodeList;
	this.DOMNodeList(ownerDocument, parentNode);
};
DOMNamedNodeMap.prototype = new DOMNodeList;

/**
 * @method DOMNamedNodeMap.getNamedItem - Retrieves a node specified by name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	name : string - Name of a node to retrieve
 *
 * @return : DOMNode
 */
DOMNamedNodeMap.prototype.getNamedItem = function DOMNamedNodeMap_getNamedItem(name) {
	var ret = null;

	// test that Named Node exists
	var itemIndex = this._findNamedItemIndex(name);

	if (itemIndex > -1) {							// found it!
	ret = this._nodes[itemIndex];				// return NamedNode
	}

	return ret;									// if node is not found, default value null is returned
};

/**
 * @method DOMNamedNodeMap.setNamedItem - Adds a node using its nodeName attribute
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	arg : DOMNode - A node to store in a named node map.
 *	 The node will later be accessible using the value of the nodeName attribute of the node.
 *	 If a node with that name is already present in the map, it is replaced by the new one.
 *
 * @throws : DOMException - WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than the one that created this map.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this NamedNodeMap is readonly.
 * @throws : DOMException - INUSE_ATTRIBUTE_ERR: Raised if arg is an Attr that is already an attribute of another Element object.
 *	The DOM user must explicitly clone Attr nodes to re-use them in other elements.
 *
 * @return : DOMNode - If the new Node replaces an existing node with the same name the previously existing Node is returned,
 *	 otherwise null is returned
 */
DOMNamedNodeMap.prototype.setNamedItem = function DOMNamedNodeMap_setNamedItem(arg) {
	// test for exceptions
	if (this.ownerDocument.implementation.errorChecking) {
	// throw Exception if arg was not created by this Document
	if (this.ownerDocument != arg.ownerDocument) {
		throw(new DOMException(DOMException.WRONG_DOCUMENT_ERR));
	}

	// throw Exception if DOMNamedNodeMap is readonly
	if (this._readonly || (this.parentNode && this.parentNode._readonly)) {
		throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// throw Exception if arg is already an attribute of another Element object
	if (arg.ownerElement && (arg.ownerElement != this.parentNode)) {
		throw(new DOMException(DOMException.INUSE_ATTRIBUTE_ERR));
	}
	}

	// get item index
	var itemIndex = this._findNamedItemIndex(arg.name);
	var ret = null;

	if (itemIndex > -1) {							// found it!
	ret = this._nodes[itemIndex];				// use existing Attribute

	// throw Exception if DOMAttr is readonly
	if (this.ownerDocument.implementation.errorChecking && ret._readonly) {
		throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}
	else {
		this._nodes[itemIndex] = arg;				// over-write existing NamedNode
	}
	}
	else {
	this._nodes[this.length] = arg;				// add new NamedNode
	}

	this.length = this._nodes.length;				// update length

	arg.ownerElement = this.parentNode;			// update ownerElement

	return ret;									// return old node or null
};

/**
 * @method DOMNamedNodeMap.removeNamedItem - Removes a node specified by name.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	name : string - The name of a node to remove
 *
 * @throws : DOMException - NOT_FOUND_ERR: Raised if there is no node named name in this map.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this NamedNodeMap is readonly.
 *
 * @return : DOMNode - The node removed from the map or null if no node with such a name exists.
 */
DOMNamedNodeMap.prototype.removeNamedItem = function DOMNamedNodeMap_removeNamedItem(name) {
	var ret = null;
	// test for exceptions
	// throw Exception if DOMNamedNodeMap is readonly
	if (this.ownerDocument.implementation.errorChecking && (this._readonly || (this.parentNode && this.parentNode._readonly))) {
	throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// get item index
	var itemIndex = this._findNamedItemIndex(name);

	// throw Exception if there is no node named name in this map
	if (this.ownerDocument.implementation.errorChecking && (itemIndex < 0)) {
	throw(new DOMException(DOMException.NOT_FOUND_ERR));
	}

	// get Node
	var oldNode = this._nodes[itemIndex];

	// throw Exception if Node is readonly
	if (this.ownerDocument.implementation.errorChecking && oldNode._readonly) {
	throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// return removed node
	return this._removeChild(itemIndex);
};

/**
 * @method DOMNamedNodeMap.getNamedItemNS - Retrieves a node specified by name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	namespaceURI : string - the namespace URI of the required node
 * @param	localName	: string - the local name of the required node
 *
 * @return : DOMNode
 */
DOMNamedNodeMap.prototype.getNamedItemNS = function DOMNamedNodeMap_getNamedItemNS(namespaceURI, localName) {
	var ret = null;

	// test that Named Node exists
	var itemIndex = this._findNamedItemNSIndex(namespaceURI, localName);

	if (itemIndex > -1) {							// found it!
	ret = this._nodes[itemIndex];				// return NamedNode
	}

	return ret;									// if node is not found, default value null is returned
};

/**
 * @method DOMNamedNodeMap.setNamedItemNS - Adds a node using
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	arg : string - A node to store in a named node map.
 *	 The node will later be accessible using the value of the nodeName attribute of the node.
 *	 If a node with that name is already present in the map, it is replaced by the new one.
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this NamedNodeMap is readonly.
 * @throws : DOMException - WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than the one that created this map.
 * @throws : DOMException - INUSE_ATTRIBUTE_ERR: Raised if arg is an Attr that is already an attribute of another Element object.
 *	 The DOM user must explicitly clone Attr nodes to re-use them in other elements.
 *
 * @return : DOMNode - If the new Node replaces an existing node with the same name the previously existing Node is returned,
 *	 otherwise null is returned
 */
DOMNamedNodeMap.prototype.setNamedItemNS = function DOMNamedNodeMap_setNamedItemNS(arg) {
	// test for exceptions
	if (this.ownerDocument.implementation.errorChecking) {
	// throw Exception if DOMNamedNodeMap is readonly
	if (this._readonly || (this.parentNode && this.parentNode._readonly)) {
		throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// throw Exception if arg was not created by this Document
	if (this.ownerDocument != arg.ownerDocument) {
		throw(new DOMException(DOMException.WRONG_DOCUMENT_ERR));
	}

	// throw Exception if arg is already an attribute of another Element object
	if (arg.ownerElement && (arg.ownerElement != this.parentNode)) {
		throw(new DOMException(DOMException.INUSE_ATTRIBUTE_ERR));
	}
	}

	// get item index
	var itemIndex = this._findNamedItemNSIndex(arg.namespaceURI, arg.localName);
	var ret = null;

	if (itemIndex > -1) {							// found it!
	ret = this._nodes[itemIndex];				// use existing Attribute
	// throw Exception if DOMAttr is readonly
	if (this.ownerDocument.implementation.errorChecking && ret._readonly) {
		throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}
	else {
		this._nodes[itemIndex] = arg;				// over-write existing NamedNode
	}
	}
	else {
	this._nodes[this.length] = arg;				// add new NamedNode
	}

	this.length = this._nodes.length;				// update length

	arg.ownerElement = this.parentNode;


	return ret;									// return old node or null
};

/**
 * @method DOMNamedNodeMap.removeNamedItemNS - Removes a node specified by name.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	namespaceURI : string - the namespace URI of the required node
 * @param	localName	: string - the local name of the required node
 *
 * @throws : DOMException - NOT_FOUND_ERR: Raised if there is no node with the specified namespaceURI and localName in this map.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this NamedNodeMap is readonly.
 *
 * @return : DOMNode - The node removed from the map or null if no node with such a name exists.
 */
DOMNamedNodeMap.prototype.removeNamedItemNS = function DOMNamedNodeMap_removeNamedItemNS(namespaceURI, localName) {
	var ret = null;

	// test for exceptions
	// throw Exception if DOMNamedNodeMap is readonly
	if (this.ownerDocument.implementation.errorChecking && (this._readonly || (this.parentNode && this.parentNode._readonly))) {
	throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// get item index
	var itemIndex = this._findNamedItemNSIndex(namespaceURI, localName);

	// throw Exception if there is no matching node in this map
	if (this.ownerDocument.implementation.errorChecking && (itemIndex < 0)) {
	throw(new DOMException(DOMException.NOT_FOUND_ERR));
	}

	// get Node
	var oldNode = this._nodes[itemIndex];

	// throw Exception if Node is readonly
	if (this.ownerDocument.implementation.errorChecking && oldNode._readonly) {
	throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	return this._removeChild(itemIndex);			 // return removed node
};

/**
 * @method DOMNamedNodeMap._findNamedItemIndex - find the item index of the node with the specified name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	name : string - the name of the required node
 *
 * @return : int
 */
DOMNamedNodeMap.prototype._findNamedItemIndex = function DOMNamedNodeMap__findNamedItemIndex(name) {
	var ret = -1;

	// loop through all nodes
	for (var i=0; i<this._nodes.length; i++) {
	// compare name to each node's nodeName
	if (this._nodes[i].name == name) {		 // found it!
		ret = i;
		break;
	}
	}

	return ret;									// if node is not found, default value -1 is returned
};

/**
 * @method DOMNamedNodeMap._findNamedItemNSIndex - find the item index of the node with the specified namespaceURI and localName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	namespaceURI : string - the namespace URI of the required node
 * @param	localName	: string - the local name of the required node
 *
 * @return : int
 */
DOMNamedNodeMap.prototype._findNamedItemNSIndex = function DOMNamedNodeMap__findNamedItemNSIndex(namespaceURI, localName) {
	var ret = -1;

	// test that localName is not null
	if (localName) {
	// loop through all nodes
	for (var i=0; i<this._nodes.length; i++) {
		// compare name to each node's namespaceURI and localName
		if ((this._nodes[i].namespaceURI == namespaceURI) && (this._nodes[i].localName == localName)) {
		ret = i;								 // found it!
		break;
		}
	}
	}

	return ret;									// if node is not found, default value -1 is returned
};

/**
 * @method DOMNamedNodeMap._hasAttribute - Returns true if specified node exists
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	name : string - the name of the required node
 *
 * @return : boolean
 */
DOMNamedNodeMap.prototype._hasAttribute = function DOMNamedNodeMap__hasAttribute(name) {
	var ret = false;

	// test that Named Node exists
	var itemIndex = this._findNamedItemIndex(name);

	if (itemIndex > -1) {							// found it!
	ret = true;									// return true
	}

	return ret;									// if node is not found, default value false is returned
}

/**
 * @method DOMNamedNodeMap._hasAttributeNS - Returns true if specified node exists
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	namespaceURI : string - the namespace URI of the required node
 * @param	localName	: string - the local name of the required node
 *
 * @return : boolean
 */
DOMNamedNodeMap.prototype._hasAttributeNS = function DOMNamedNodeMap__hasAttributeNS(namespaceURI, localName) {
	var ret = false;

	// test that Named Node exists
	var itemIndex = this._findNamedItemNSIndex(namespaceURI, localName);

	if (itemIndex > -1) {							// found it!
	ret = true;									// return true
	}

	return ret;									// if node is not found, default value false is returned
}

/**
 * @method DOMNamedNodeMap._cloneNodes - Returns a NamedNodeMap containing clones of the Nodes in this NamedNodeMap
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	parentNode : DOMNode - the new parent of the cloned NodeList
 *
 * @return : DOMNamedNodeMap - NamedNodeMap containing clones of the Nodes in this DOMNamedNodeMap
 */
DOMNamedNodeMap.prototype._cloneNodes = function DOMNamedNodeMap__cloneNodes(parentNode) {
	var cloneNamedNodeMap = new DOMNamedNodeMap(this.ownerDocument, parentNode);

	// create list containing clones of all children
	for (var i=0; i < this._nodes.length; i++) {
	cloneNamedNodeMap._appendChild(this._nodes[i].cloneNode(false));
	}

	return cloneNamedNodeMap;
};

/**
 * @method DOMNamedNodeMap.toString - Serialize this NodeMap into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMNamedNodeMap.prototype.toString = function DOMNamedNodeMap_toString() {
	var ret = "";

	// create string containing concatenation of all (but last) Attribute string values (separated by spaces)
	for (var i=0; i < this.length -1; i++) {
	ret += this._nodes[i].toString() +" ";
	}

	// add last Attribute to string (without trailing space)
	if (this.length > 0) {
	ret += this._nodes[this.length -1].toString();
	}

	return ret;
};

/**
 * @class	DOMNamespaceNodeMap - used to represent collections of namespace nodes that can be accessed by name
 *	typically a set of Element attributes
 *
 * @extends DOMNamedNodeMap
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	ownerDocument : DOMDocument - the ownerDocument
 * @param	parentNode	: DOMNode - the node that the DOMNamespaceNodeMap is attached to (or null)
 */
DOMNamespaceNodeMap = function(ownerDocument, parentNode) {
	this._class = addClass(this._class, "DOMNamespaceNodeMap");
	this.DOMNamedNodeMap = DOMNamedNodeMap;
	this.DOMNamedNodeMap(ownerDocument, parentNode);
};
DOMNamespaceNodeMap.prototype = new DOMNamedNodeMap;

/**
 * @method DOMNamespaceNodeMap._findNamedItemIndex - find the item index of the node with the specified localName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	localName : string - the localName of the required node
 *
 * @return : int
 */
DOMNamespaceNodeMap.prototype._findNamedItemIndex = function DOMNamespaceNodeMap__findNamedItemIndex(localName) {
	var ret = -1;

	// loop through all nodes
	for (var i=0; i<this._nodes.length; i++) {
	// compare name to each node's nodeName
	if (this._nodes[i].localName == localName) {		 // found it!
		ret = i;
		break;
	}
	}

	return ret;									// if node is not found, default value -1 is returned
};


/**
 * @method DOMNamespaceNodeMap._cloneNodes - Returns a NamespaceNodeMap containing clones of the Nodes in this NamespaceNodeMap
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	parentNode : DOMNode - the new parent of the cloned NodeList
 *
 * @return : DOMNamespaceNodeMap - NamespaceNodeMap containing clones of the Nodes in this NamespaceNodeMap
 */
DOMNamespaceNodeMap.prototype._cloneNodes = function DOMNamespaceNodeMap__cloneNodes(parentNode) {
	var cloneNamespaceNodeMap = new DOMNamespaceNodeMap(this.ownerDocument, parentNode);

	// create list containing clones of all children
	for (var i=0; i < this._nodes.length; i++) {
	cloneNamespaceNodeMap._appendChild(this._nodes[i].cloneNode(false));
	}

	return cloneNamespaceNodeMap;
};

/**
 * @method DOMNamespaceNodeMap.toString - Serialize this NamespaceNodeMap into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMNamespaceNodeMap.prototype.toString = function DOMNamespaceNodeMap_toString() {
	var ret = "";

	// identify namespaces declared local to this Element (ie, not inherited)
	for (var ind = 0; ind < this._nodes.length; ind++) {
	// if namespace declaration does not exist in the containing node's, parentNode's namespaces
	var ns = null;
	try {
		var ns = this.parentNode.parentNode._namespaces.getNamedItem(this._nodes[ind].localName);
	}
	catch (e) {
		//breaking to prevent default namespace being inserted into return value
		break;
	}
	if (!(ns && (""+ ns.nodeValue == ""+ this._nodes[ind].nodeValue))) {
		// display the namespace declaration
		ret += this._nodes[ind].toString() +" ";
	}
	}

	return ret;
};

/**
 * @class	DOMNode - The Node interface is the primary datatype for the entire Document Object Model.
 *	 It represents a single node in the document tree.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMNode = function(ownerDocument) {
	this._class = addClass(this._class, "DOMNode");

	if (ownerDocument) {
	this._id = ownerDocument._genId();			 // generate unique internal id
	}

	this.namespaceURI = "";						// The namespace URI of this node (Level 2)
	this.prefix		 = "";						// The namespace prefix of this node (Level 2)
	this.localName	= "";						// The localName of this node (Level 2)

	this.nodeName = "";							// The name of this node
	this.nodeValue = "";							 // The value of this node
	this.nodeType = 0;							 // A code representing the type of the underlying object

	// The parent of this node. All nodes, except Document, DocumentFragment, and Attr may have a parent.
	// However, if a node has just been created and not yet added to the tree, or if it has been removed from the tree, this is null
	this.parentNode		= null;

	// A NodeList that contains all children of this node. If there are no children, this is a NodeList containing no nodes.
	// The content of the returned NodeList is "live" in the sense that, for instance, changes to the children of the node object
	// that it was created from are immediately reflected in the nodes returned by the NodeList accessors;
	// it is not a static snapshot of the content of the node. This is true for every NodeList, including the ones returned by the getElementsByTagName method.
	this.childNodes		= new DOMNodeList(ownerDocument, this);

	this.firstChild		= null;					 // The first child of this node. If there is no such node, this is null
	this.lastChild		 = null;					 // The last child of this node. If there is no such node, this is null.
	this.previousSibling = null;					 // The node immediately preceding this node. If there is no such node, this is null.
	this.nextSibling	 = null;					 // The node immediately following this node. If there is no such node, this is null.

	this.attributes = new DOMNamedNodeMap(ownerDocument, this);	 // A NamedNodeMap containing the attributes of this node (if it is an Element) or null otherwise.
	this.ownerDocument	 = ownerDocument;			// The Document object associated with this node
	this._namespaces = new DOMNamespaceNodeMap(ownerDocument, this);	// The namespaces in scope for this node

	this._readonly = false;
};

// nodeType constants
DOMNode.ELEMENT_NODE				= 1;
DOMNode.ATTRIBUTE_NODE				= 2;
DOMNode.TEXT_NODE					 = 3;
DOMNode.CDATA_SECTION_NODE			= 4;
DOMNode.ENTITY_REFERENCE_NODE		 = 5;
DOMNode.ENTITY_NODE				 = 6;
DOMNode.PROCESSING_INSTRUCTION_NODE = 7;
DOMNode.COMMENT_NODE				= 8;
DOMNode.DOCUMENT_NODE				 = 9;
DOMNode.DOCUMENT_TYPE_NODE			= 10;
DOMNode.DOCUMENT_FRAGMENT_NODE		= 11;
DOMNode.NOTATION_NODE				 = 12;
DOMNode.NAMESPACE_NODE				= 13;

/**
 * @method DOMNode.hasAttributes
 *
 * @author Jon van Noort (jon@webarcana.com.au) & David Joham (djoham@yahoo.com)
 *
 * @return : boolean
 */
DOMNode.prototype.hasAttributes = function DOMNode_hasAttributes() {
	if (this.attributes.length == 0) {
		return false;
	}
	else {
		return true;
	}
};

/**
 * @method DOMNode.getNodeName - Java style gettor for .nodeName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMNode.prototype.getNodeName = function DOMNode_getNodeName() {
	return this.nodeName;
};

/**
 * @method DOMNode.getNodeValue - Java style gettor for .NodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMNode.prototype.getNodeValue = function DOMNode_getNodeValue() {
	return this.nodeValue;
};

/**
 * @method DOMNode.setNodeValue - Java style settor for .NodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	nodeValue : string - unique internal id
 */
DOMNode.prototype.setNodeValue = function DOMNode_setNodeValue(nodeValue) {
	// throw Exception if DOMNode is readonly
	if (this.ownerDocument.implementation.errorChecking && this._readonly) {
	throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	this.nodeValue = nodeValue;
};

/**
 * @method DOMNode.getNodeType - Java style gettor for .nodeType
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : int
 */
DOMNode.prototype.getNodeType = function DOMNode_getNodeType() {
	return this.nodeType;
};

/**
 * @method DOMNode.getParentNode - Java style gettor for .parentNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMNode
 */
DOMNode.prototype.getParentNode = function DOMNode_getParentNode() {
	return this.parentNode;
};

/**
 * @method DOMNode.getChildNodes - Java style gettor for .childNodes
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMNodeList
 */
DOMNode.prototype.getChildNodes = function DOMNode_getChildNodes() {
	return this.childNodes;
};

/**
 * @method DOMNode.getFirstChild - Java style gettor for .firstChild
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMNode
 */
DOMNode.prototype.getFirstChild = function DOMNode_getFirstChild() {
	return this.firstChild;
};

/**
 * @method DOMNode.getLastChild - Java style gettor for .lastChild
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMNode
 */
DOMNode.prototype.getLastChild = function DOMNode_getLastChild() {
	return this.lastChild;
};

/**
 * @method DOMNode.getPreviousSibling - Java style gettor for .previousSibling
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMNode
 */
DOMNode.prototype.getPreviousSibling = function DOMNode_getPreviousSibling() {
	return this.previousSibling;
};

/**
 * @method DOMNode.getNextSibling - Java style gettor for .nextSibling
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMNode
 */
DOMNode.prototype.getNextSibling = function DOMNode_getNextSibling() {
	return this.nextSibling;
};

/**
 * @method DOMNode.getAttributes - Java style gettor for .attributes
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMNamedNodeList
 */
DOMNode.prototype.getAttributes = function DOMNode_getAttributes() {
	return this.attributes;
};

/**
 * @method DOMNode.getOwnerDocument - Java style gettor for .ownerDocument
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMDocument
 */
DOMNode.prototype.getOwnerDocument = function DOMNode_getOwnerDocument() {
	return this.ownerDocument;
};

/**
 * @method DOMNode.getNamespaceURI - Java style gettor for .namespaceURI
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : String
 */
DOMNode.prototype.getNamespaceURI = function DOMNode_getNamespaceURI() {
	return this.namespaceURI;
};

/**
 * @method DOMNode.getPrefix - Java style gettor for .prefix
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : String
 */
DOMNode.prototype.getPrefix = function DOMNode_getPrefix() {
	return this.prefix;
};

/**
 * @method DOMNode.setPrefix - Java style settor for .prefix
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	 prefix : String
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Node is readonly.
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 * @throws : DOMException - NAMESPACE_ERR: Raised if the Namespace is invalid
 *
 */
DOMNode.prototype.setPrefix = function DOMNode_setPrefix(prefix) {
	// test for exceptions
	if (this.ownerDocument.implementation.errorChecking) {
	// throw Exception if DOMNode is readonly
	if (this._readonly) {
		throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// throw Exception if the prefix string contains an illegal character
	if (!this.ownerDocument.implementation._isValidName(prefix)) {
		throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
	}

	// throw Exception if the Namespace is invalid;
	//	if the specified prefix is malformed,
	//	if the namespaceURI of this node is null,
	//	if the specified prefix is "xml" and the namespaceURI of this node is
	//	 different from "http://www.w3.org/XML/1998/namespace",
	if (!this.ownerDocument._isValidNamespace(this.namespaceURI, prefix +":"+ this.localName)) {
		throw(new DOMException(DOMException.NAMESPACE_ERR));
	}

	// throw Exception if we are trying to make the attribute look like a namespace declaration;
	//	if this node is an attribute and the specified prefix is "xmlns"
	//	 and the namespaceURI of this node is different from "http://www.w3.org/2000/xmlns/",
	if ((prefix == "xmlns") && (this.namespaceURI != "http://www.w3.org/2000/xmlns/")) {
		throw(new DOMException(DOMException.NAMESPACE_ERR));
	}

	// throw Exception if we are trying to make the attribute look like a default namespace declaration;
	//	if this node is an attribute and the qualifiedName of this node is "xmlns" [Namespaces].
	if ((prefix == "") && (this.localName == "xmlns")) {
		throw(new DOMException(DOMException.NAMESPACE_ERR));
	}
	}

	// update prefix
	this.prefix = prefix;

	// update nodeName (QName)
	if (this.prefix != "") {
	this.nodeName = this.prefix +":"+ this.localName;
	}
	else {
	this.nodeName = this.localName;	// no prefix, therefore nodeName is simply localName
	}
};

/**
 * @method DOMNode.getLocalName - Java style gettor for .localName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : String
 */
DOMNode.prototype.getLocalName = function DOMNode_getLocalName() {
	return this.localName;
};

/**
 * @method DOMNode.insertBefore - Inserts the node newChild before the existing child node refChild.
 *	 If refChild is null, insert newChild at the end of the list of children.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	newChild : DOMNode - The node to insert.
 * @param	refChild : DOMNode - The reference node, i.e., the node before which the new node must be inserted
 *
 * @throws : DOMException - HIERARCHY_REQUEST_ERR: Raised if the node to insert is one of this node's ancestors
 * @throws : DOMException - WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than the one that created this map.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Node is readonly.
 * @throws : DOMException - NOT_FOUND_ERR: Raised if there is no node named name in this map.
 *
 * @return : DOMNode - The node being inserted.
 */
DOMNode.prototype.insertBefore = function DOMNode_insertBefore(newChild, refChild) {
	var prevNode;

	// test for exceptions
	if (this.ownerDocument.implementation.errorChecking) {
	// throw Exception if DOMNode is readonly
	if (this._readonly) {
		throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// throw Exception if newChild was not created by this Document
	if (this.ownerDocument != newChild.ownerDocument) {
		throw(new DOMException(DOMException.WRONG_DOCUMENT_ERR));
	}

	// throw Exception if the node is an ancestor
	if (this._isAncestor(newChild)) {
		throw(new DOMException(DOMException.HIERARCHY_REQUEST_ERR));
	}
	}

	if (refChild) {								// if refChild is specified, insert before it
	// find index of refChild
	var itemIndex = this.childNodes._findItemIndex(refChild._id);

	// throw Exception if there is no child node with this id
	if (this.ownerDocument.implementation.errorChecking && (itemIndex < 0)) {
		throw(new DOMException(DOMException.NOT_FOUND_ERR));
	}

	// if the newChild is already in the tree,
	var newChildParent = newChild.parentNode;
	if (newChildParent) {
		// remove it
		newChildParent.removeChild(newChild);
	}

	// insert newChild into childNodes
	this.childNodes._insertBefore(newChild, this.childNodes._findItemIndex(refChild._id));

	// do node pointer surgery
	prevNode = refChild.previousSibling;

	// handle DocumentFragment
	if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {
		if (newChild.childNodes._nodes.length > 0) {
		// set the parentNode of DocumentFragment's children
		for (var ind = 0; ind < newChild.childNodes._nodes.length; ind++) {
			newChild.childNodes._nodes[ind].parentNode = this;
		}

		// link refChild to last child of DocumentFragment
		refChild.previousSibling = newChild.childNodes._nodes[newChild.childNodes._nodes.length-1];
		}
	}
	else {
		newChild.parentNode = this;				// set the parentNode of the newChild
		refChild.previousSibling = newChild;		 // link refChild to newChild
	}
	}
	else {										 // otherwise, append to end
	prevNode = this.lastChild;
	this.appendChild(newChild);
	}

	if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {
	// do node pointer surgery for DocumentFragment
	if (newChild.childNodes._nodes.length > 0) {
		if (prevNode) {
		prevNode.nextSibling = newChild.childNodes._nodes[0];
		}
		else {										 // this is the first child in the list
		this.firstChild = newChild.childNodes._nodes[0];
		}

		newChild.childNodes._nodes[0].previousSibling = prevNode;
		newChild.childNodes._nodes[newChild.childNodes._nodes.length-1].nextSibling = refChild;
	}
	}
	else {
	// do node pointer surgery for newChild
	if (prevNode) {
		prevNode.nextSibling = newChild;
	}
	else {										 // this is the first child in the list
		this.firstChild = newChild;
	}

	newChild.previousSibling = prevNode;
	newChild.nextSibling	 = refChild;
	}

	return newChild;
};

/**
 * @method DOMNode.replaceChild - Replaces the child node oldChild with newChild in the list of children,
 *	 and returns the oldChild node.
 *	 If the newChild is already in the tree, it is first removed.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	newChild : DOMNode - The node to insert.
 * @param	oldChild : DOMNode - The node being replaced in the list.
 *
 * @throws : DOMException - HIERARCHY_REQUEST_ERR: Raised if the node to insert is one of this node's ancestors
 * @throws : DOMException - WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than the one that created this map.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Node is readonly.
 * @throws : DOMException - NOT_FOUND_ERR: Raised if there is no node named name in this map.
 *
 * @return : DOMNode - The node that was replaced
 */
DOMNode.prototype.replaceChild = function DOMNode_replaceChild(newChild, oldChild) {
	var ret = null;

	// test for exceptions
	if (this.ownerDocument.implementation.errorChecking) {
	// throw Exception if DOMNode is readonly
	if (this._readonly) {
		throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// throw Exception if newChild was not created by this Document
	if (this.ownerDocument != newChild.ownerDocument) {
		throw(new DOMException(DOMException.WRONG_DOCUMENT_ERR));
	}

	// throw Exception if the node is an ancestor
	if (this._isAncestor(newChild)) {
		throw(new DOMException(DOMException.HIERARCHY_REQUEST_ERR));
	}
	}

	// get index of oldChild
	var index = this.childNodes._findItemIndex(oldChild._id);

	// throw Exception if there is no child node with this id
	if (this.ownerDocument.implementation.errorChecking && (index < 0)) {
	throw(new DOMException(DOMException.NOT_FOUND_ERR));
	}

	// if the newChild is already in the tree,
	var newChildParent = newChild.parentNode;
	if (newChildParent) {
	// remove it
	newChildParent.removeChild(newChild);
	}

	// add newChild to childNodes
	ret = this.childNodes._replaceChild(newChild, index);


	if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {
	// do node pointer surgery for Document Fragment
	if (newChild.childNodes._nodes.length > 0) {
		for (var ind = 0; ind < newChild.childNodes._nodes.length; ind++) {
		newChild.childNodes._nodes[ind].parentNode = this;
		}

		if (oldChild.previousSibling) {
		oldChild.previousSibling.nextSibling = newChild.childNodes._nodes[0];
		}
		else {
		this.firstChild = newChild.childNodes._nodes[0];
		}

		if (oldChild.nextSibling) {
		oldChild.nextSibling.previousSibling = newChild;
		}
		else {
		this.lastChild = newChild.childNodes._nodes[newChild.childNodes._nodes.length-1];
		}

		newChild.childNodes._nodes[0].previousSibling = oldChild.previousSibling;
		newChild.childNodes._nodes[newChild.childNodes._nodes.length-1].nextSibling = oldChild.nextSibling;
	}
	}
	else {
	// do node pointer surgery for newChild
	newChild.parentNode = this;

	if (oldChild.previousSibling) {
		oldChild.previousSibling.nextSibling = newChild;
	}
	else {
		this.firstChild = newChild;
	}
	if (oldChild.nextSibling) {
		oldChild.nextSibling.previousSibling = newChild;
	}
	else {
		this.lastChild = newChild;
	}
	newChild.previousSibling = oldChild.previousSibling;
	newChild.nextSibling = oldChild.nextSibling;
	}
	return ret;
};

/**
 * @method DOMNode.removeChild - Removes the child node indicated by oldChild from the list of children, and returns it.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	oldChild : DOMNode - The node being removed.
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Node is readonly.
 * @throws : DOMException - NOT_FOUND_ERR: Raised if there is no node named name in this map.
 *
 * @return : DOMNode - The node being removed.
 */
DOMNode.prototype.removeChild = function DOMNode_removeChild(oldChild) {
	// throw Exception if DOMNamedNodeMap is readonly
	if (this.ownerDocument.implementation.errorChecking && (this._readonly || oldChild._readonly)) {
	throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// get index of oldChild
	var itemIndex = this.childNodes._findItemIndex(oldChild._id);

	// throw Exception if there is no child node with this id
	if (this.ownerDocument.implementation.errorChecking && (itemIndex < 0)) {
	throw(new DOMException(DOMException.NOT_FOUND_ERR));
	}

	// remove oldChild from childNodes
	this.childNodes._removeChild(itemIndex);

	// do node pointer surgery
	oldChild.parentNode = null;

	if (oldChild.previousSibling) {
	oldChild.previousSibling.nextSibling = oldChild.nextSibling;
	}
	else {
	this.firstChild = oldChild.nextSibling;
	}
	if (oldChild.nextSibling) {
	oldChild.nextSibling.previousSibling = oldChild.previousSibling;
	}
	else {
	this.lastChild = oldChild.previousSibling;
	}

	oldChild.previousSibling = null;
	oldChild.nextSibling = null;
	return oldChild;
};

/**
 * @method DOMNode.appendChild - Adds the node newChild to the end of the list of children of this node.
 *	 If the newChild is already in the tree, it is first removed.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	newChild : DOMNode - The node to add
 *
 * @throws : DOMException - HIERARCHY_REQUEST_ERR: Raised if the node to insert is one of this node's ancestors
 * @throws : DOMException - WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than the one that created this map.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Node is readonly.
 *
 * @return : DOMNode - The node added
 */
DOMNode.prototype.appendChild = function DOMNode_appendChild(newChild) {
	// test for exceptions
	if (this.ownerDocument.implementation.errorChecking) {
	// throw Exception if Node is readonly
	if (this._readonly) {
		throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// throw Exception if arg was not created by this Document
	if (this.ownerDocument != newChild.ownerDocument) {
		throw(new DOMException(DOMException.WRONG_DOCUMENT_ERR));
	}

	// throw Exception if the node is an ancestor
	if (this._isAncestor(newChild)) {
		throw(new DOMException(DOMException.HIERARCHY_REQUEST_ERR));
	}
	}

	// if the newChild is already in the tree,
	var newChildParent = newChild.parentNode;
	if (newChildParent) {
	// remove it
	newChildParent.removeChild(newChild);
	}

	// add newChild to childNodes
	this.childNodes._appendChild(newChild);

	if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {
	// do node pointer surgery for DocumentFragment
	if (newChild.childNodes._nodes.length > 0) {
		for (var ind = 0; ind < newChild.childNodes._nodes.length; ind++) {
		newChild.childNodes._nodes[ind].parentNode = this;
		}

		if (this.lastChild) {
		this.lastChild.nextSibling = newChild.childNodes._nodes[0];
		newChild.childNodes._nodes[0].previousSibling = this.lastChild;
		this.lastChild = newChild.childNodes._nodes[newChild.childNodes._nodes.length-1];
		}
		else {
		this.lastChild = newChild.childNodes._nodes[newChild.childNodes._nodes.length-1];
		this.firstChild = newChild.childNodes._nodes[0];
		}
	}
	}
	else {
	// do node pointer surgery for newChild
	newChild.parentNode = this;
	if (this.lastChild) {
		this.lastChild.nextSibling = newChild;
		newChild.previousSibling = this.lastChild;
		this.lastChild = newChild;
	}
	else {
		this.lastChild = newChild;
		this.firstChild = newChild;
	}
	}

	return newChild;
};

/**
 * @method DOMNode.hasChildNodes - This is a convenience method to allow easy determination of whether a node has any children.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : boolean - true if the node has any children, false if the node has no children
 */
DOMNode.prototype.hasChildNodes = function DOMNode_hasChildNodes() {
	return (this.childNodes.length > 0);
};

/**
 * @method DOMNode.cloneNode - Returns a duplicate of this node, i.e., serves as a generic copy constructor for nodes.
 *	 The duplicate node has no parent (parentNode returns null.).
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	deep : boolean - If true, recursively clone the subtree under the specified node;
 *	 if false, clone only the node itself (and its attributes, if it is an Element).
 *
 * @return : DOMNode
 */
DOMNode.prototype.cloneNode = function DOMNode_cloneNode(deep) {
	// use importNode to clone this Node
	//do not throw any exceptions
	try {
	 return this.ownerDocument.importNode(this, deep);
	}
	catch (e) {
	 //there shouldn't be any exceptions, but if there are, return null
	 return null;
	}
};

/**
 * @method DOMNode.normalize - Puts all Text nodes in the full depth of the sub-tree underneath this Element into a "normal" form
 *	 where only markup (e.g., tags, comments, processing instructions, CDATA sections, and entity references) separates Text nodes,
 *	 i.e., there are no adjacent Text nodes.
 *
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 */
DOMNode.prototype.normalize = function DOMNode_normalize() {
	var inode;
	var nodesToRemove = new DOMNodeList();

	if (this.nodeType == DOMNode.ELEMENT_NODE || this.nodeType == DOMNode.DOCUMENT_NODE) {
	var adjacentTextNode = null;

	// loop through all childNodes
	for(var i = 0; i < this.childNodes.length; i++) {
		inode = this.childNodes.item(i);

		if (inode.nodeType == DOMNode.TEXT_NODE) { // this node is a text node
		if (inode.length < 1) {					// this text node is empty
			nodesToRemove._appendChild(inode);		// add this node to the list of nodes to be remove
		}
		else {
			if (adjacentTextNode) {				// if previous node was also text
			adjacentTextNode.appendData(inode.data);	 // merge the data in adjacent text nodes
			nodesToRemove._appendChild(inode);	// add this node to the list of nodes to be removed
			}
			else {
				adjacentTextNode = inode;				// remember this node for next cycle
			}
		}
		}
		else {
		adjacentTextNode = null;				 // (soon to be) previous node is not a text node
		inode.normalize();						 // normalise non Text childNodes
		}
	}

	// remove redundant Text Nodes
	for(var i = 0; i < nodesToRemove.length; i++) {
		inode = nodesToRemove.item(i);
		inode.parentNode.removeChild(inode);
	}
	}
};

/**
 * @method DOMNode.isSupported - Test if the DOM implementation implements a specific feature
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	feature : string - The package name of the feature to test. the legal only values are "XML" and "CORE" (case-insensitive).
 * @param	version : string - This is the version number of the package name to test. In Level 1, this is the string "1.0".
 *
 * @return : boolean
 */
DOMNode.prototype.isSupported = function DOMNode_isSupported(feature, version) {
	// use Implementation.hasFeature to determin if this feature is supported
	return this.ownerDocument.implementation.hasFeature(feature, version);
}

/**
 * @method DOMNode.getElementsByTagName - Returns a NodeList of all the Elements with a given tag name
 *	 in the order in which they would be encountered in a preorder traversal of the Document tree.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	tagname : string - The name of the tag to match on. The special value "*" matches all tags
 *
 * @return : DOMNodeList
 */
DOMNode.prototype.getElementsByTagName = function DOMNode_getElementsByTagName(tagname) {
	// delegate to _getElementsByTagNameRecursive
	return this._getElementsByTagNameRecursive(tagname, new DOMNodeList(this.ownerDocument));
};

/**
 * @method DOMNode._getElementsByTagNameRecursive - implements getElementsByTagName()
 *
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 *
 * @param	tagname	: string		- The name of the tag to match on. The special value "*" matches all tags
 * @param	nodeList : DOMNodeList - The accumulating list of matching nodes
 *
 * @return : DOMNodeList
 */
DOMNode.prototype._getElementsByTagNameRecursive = function DOMNode__getElementsByTagNameRecursive(tagname, nodeList) {
	if (this.nodeType == DOMNode.ELEMENT_NODE || this.nodeType == DOMNode.DOCUMENT_NODE) {

	if((this.nodeName == tagname) || (tagname == "*")) {
		nodeList._appendChild(this);				 // add matching node to nodeList
	}

	// recurse childNodes
	for(var i = 0; i < this.childNodes.length; i++) {
		nodeList = this.childNodes.item(i)._getElementsByTagNameRecursive(tagname, nodeList);
	}
	}

	return nodeList;
};

/**
 * @method DOMNode.getXML - Returns the String XML of the node and all of its children
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string - XML String of the XML of the node and all of its children
 */
DOMNode.prototype.getXML = function DOMNode_getXML() {
	return this.toString();
}


/**
 * @method DOMNode.getElementsByTagNameNS - Returns a NodeList of all the Elements with a given namespaceURI and localName
 *	 in the order in which they would be encountered in a preorder traversal of the Document tree.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	namespaceURI : string - the namespace URI of the required node
 * @param	localName	: string - the local name of the required node
 *
 * @return : DOMNodeList
 */
DOMNode.prototype.getElementsByTagNameNS = function DOMNode_getElementsByTagNameNS(namespaceURI, localName) {
	// delegate to _getElementsByTagNameNSRecursive
	return this._getElementsByTagNameNSRecursive(namespaceURI, localName, new DOMNodeList(this.ownerDocument));
};

/**
 * @method DOMNode._getElementsByTagNameNSRecursive - implements getElementsByTagName()
 *
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 *
 * @param	namespaceURI : string - the namespace URI of the required node
 * @param	localName	: string - the local name of the required node
 * @param	nodeList	 : DOMNodeList - The accumulating list of matching nodes
 *
 * @return : DOMNodeList
 */
DOMNode.prototype._getElementsByTagNameNSRecursive = function DOMNode__getElementsByTagNameNSRecursive(namespaceURI, localName, nodeList) {
	if (this.nodeType == DOMNode.ELEMENT_NODE || this.nodeType == DOMNode.DOCUMENT_NODE) {

	if (((this.namespaceURI == namespaceURI) || (namespaceURI == "*")) && ((this.localName == localName) || (localName == "*"))) {
		nodeList._appendChild(this);				 // add matching node to nodeList
	}

	// recurse childNodes
	for(var i = 0; i < this.childNodes.length; i++) {
		nodeList = this.childNodes.item(i)._getElementsByTagNameNSRecursive(namespaceURI, localName, nodeList);
	}
	}

	return nodeList;
};

/**
 * @method DOMNode._isAncestor - returns true if node is ancestor of this
 *
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 *
 * @param	node		 : DOMNode - The candidate ancestor node
 *
 * @return : boolean
 */
DOMNode.prototype._isAncestor = function DOMNode__isAncestor(node) {
	// if this node matches, return true,
	// otherwise recurse up (if there is a parentNode)
	return ((this == node) || ((this.parentNode) && (this.parentNode._isAncestor(node))));
}

/**
 * @method DOMNode.importNode - Imports a node from another document to this document.
 *	 The returned node has no parent; (parentNode is null).
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	importedNode : Node - The Node to be imported
 * @param	deep		 : boolean - If true, recursively clone the subtree under the specified node;
 *	 if false, clone only the node itself (and its attributes, if it is an Element).
 *
 * @return : DOMNode
 */
DOMNode.prototype.importNode = function DOMNode_importNode(importedNode, deep) {
	var importNode;

	//there is no need to perform namespace checks since everything has already gone through them
	//in order to have gotten into the DOM in the first place. The following line
	//turns namespace checking off in ._isValidNamespace
	this.getOwnerDocument()._performingImportNodeOperation = true;

	try {
	if (importedNode.nodeType == DOMNode.ELEMENT_NODE) {
		if (!this.ownerDocument.implementation.namespaceAware) {
		// create a local Element (with the name of the importedNode)
		importNode = this.ownerDocument.createElement(importedNode.tagName);

		// create attributes matching those of the importedNode
		for(var i = 0; i < importedNode.attributes.length; i++) {
			importNode.setAttribute(importedNode.attributes.item(i).name, importedNode.attributes.item(i).value);
		}
		}
		else {
		// create a local Element (with the name & namespaceURI of the importedNode)
		importNode = this.ownerDocument.createElementNS(importedNode.namespaceURI, importedNode.nodeName);

		// create attributes matching those of the importedNode
		for(var i = 0; i < importedNode.attributes.length; i++) {
			importNode.setAttributeNS(importedNode.attributes.item(i).namespaceURI, importedNode.attributes.item(i).name, importedNode.attributes.item(i).value);
		}

		// create namespace definitions matching those of the importedNode
		for(var i = 0; i < importedNode._namespaces.length; i++) {
			importNode._namespaces._nodes[i] = this.ownerDocument.createNamespace(importedNode._namespaces.item(i).localName);
			importNode._namespaces._nodes[i].setValue(importedNode._namespaces.item(i).value);
		}
		}
	}
	else if (importedNode.nodeType == DOMNode.ATTRIBUTE_NODE) {
		if (!this.ownerDocument.implementation.namespaceAware) {
		// create a local Attribute (with the name of the importedAttribute)
		importNode = this.ownerDocument.createAttribute(importedNode.name);
		}
		else {
		// create a local Attribute (with the name & namespaceURI of the importedAttribute)
		importNode = this.ownerDocument.createAttributeNS(importedNode.namespaceURI, importedNode.nodeName);

		// create namespace definitions matching those of the importedAttribute
		for(var i = 0; i < importedNode._namespaces.length; i++) {
			importNode._namespaces._nodes[i] = this.ownerDocument.createNamespace(importedNode._namespaces.item(i).localName);
			importNode._namespaces._nodes[i].setValue(importedNode._namespaces.item(i).value);
		}
		}

		// set the value of the local Attribute to match that of the importedAttribute
		importNode.setValue(importedNode.value);
	}
	else if (importedNode.nodeType == DOMNode.DOCUMENT_FRAGMENT) {
		// create a local DocumentFragment
		importNode = this.ownerDocument.createDocumentFragment();
	}
	else if (importedNode.nodeType == DOMNode.NAMESPACE_NODE) {
		// create a local NamespaceNode (with the same name & value as the importedNode)
		importNode = this.ownerDocument.createNamespace(importedNode.nodeName);
		importNode.setValue(importedNode.value);
	}
	else if (importedNode.nodeType == DOMNode.TEXT_NODE) {
		// create a local TextNode (with the same data as the importedNode)
		importNode = this.ownerDocument.createTextNode(importedNode.data);
	}
	else if (importedNode.nodeType == DOMNode.CDATA_SECTION_NODE) {
		// create a local CDATANode (with the same data as the importedNode)
		importNode = this.ownerDocument.createCDATASection(importedNode.data);
	}
	else if (importedNode.nodeType == DOMNode.PROCESSING_INSTRUCTION_NODE) {
		// create a local ProcessingInstruction (with the same target & data as the importedNode)
		importNode = this.ownerDocument.createProcessingInstruction(importedNode.target, importedNode.data);
	}
	else if (importedNode.nodeType == DOMNode.COMMENT_NODE) {
		// create a local Comment (with the same data as the importedNode)
		importNode = this.ownerDocument.createComment(importedNode.data);
	}
	else {	// throw Exception if nodeType is not supported
		throw(new DOMException(DOMException.NOT_SUPPORTED_ERR));
	}

	if (deep) {									// recurse childNodes
		for(var i = 0; i < importedNode.childNodes.length; i++) {
		importNode.appendChild(this.ownerDocument.importNode(importedNode.childNodes.item(i), true));
		}
	}

	//reset _performingImportNodeOperation
	this.getOwnerDocument()._performingImportNodeOperation = false;
	return importNode;
	}
	catch (eAny) {
	//reset _performingImportNodeOperation
	this.getOwnerDocument()._performingImportNodeOperation = false;

	//re-throw the exception
	throw eAny;
	}//djotemp
};

/**
 * @method DOMNode.escapeString - escape special characters
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	str : string - The string to be escaped
 *
 * @return : string - The escaped string
 */
DOMNode.prototype.__escapeString = function DOMNode__escapeString(str) {

	//the sax processor already has this function. Just wrap it
	return __escapeString(str);
};

/**
 * @method DOMNode.unescapeString - unescape special characters
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	str : string - The string to be unescaped
 *
 * @return : string - The unescaped string
 */
DOMNode.prototype.__unescapeString = function DOMNode__unescapeString(str) {

	//the sax processor already has this function. Just wrap it
	return __unescapeString(str);
};



/**
 * @class	DOMDocument - The Document interface represents the entire HTML or XML document.
 *	 Conceptually, it is the root of the document tree, and provides the primary access to the document's data.
 *
 * @extends DOMNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	implementation : DOMImplementation - the creator Implementation
 */
DOMDocument = function(implementation) {
	this._class = addClass(this._class, "DOMDocument");
	this.DOMNode = DOMNode;
	this.DOMNode(this);

	this.doctype = null;							 // The Document Type Declaration (see DocumentType) associated with this document
	this.implementation = implementation;			// The DOMImplementation object that handles this document.
	this.documentElement = null;					 // This is a convenience attribute that allows direct access to the child node that is the root element of the document
	this.all	= new Array();						 // The list of all Elements

	this.nodeName	= "#document";
	this.nodeType = DOMNode.DOCUMENT_NODE;
	this._id = 0;
	this._lastId = 0;
	this._parseComplete = false;					 // initially false, set to true by parser

	this.ownerDocument = this;

	this._performingImportNodeOperation = false;
};
DOMDocument.prototype = new DOMNode;

/**
 * @method DOMDocument.getDoctype - Java style gettor for .doctype
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMDocument
 */
DOMDocument.prototype.getDoctype = function DOMDocument_getDoctype() {
	return this.doctype;
};

/**
 * @method DOMDocument.getImplementation - Java style gettor for .implementation
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMImplementation
 */
DOMDocument.prototype.getImplementation = function DOMDocument_implementation() {
	return this.implementation;
};

/**
 * @method DOMDocument.getDocumentElement - Java style gettor for .documentElement
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMDocumentElement
 */
DOMDocument.prototype.getDocumentElement = function DOMDocument_getDocumentElement() {
	return this.documentElement;
};

/**
 * @method DOMDocument.createElement - Creates an element of the type specified.
 *	 Note that the instance returned implements the Element interface,
 *	 so attributes can be specified directly on the returned object.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	tagName : string - The name of the element type to instantiate.
 *
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 *
 * @return : DOMElement - The new Element object.
 */
DOMDocument.prototype.createElement = function DOMDocument_createElement(tagName) {
	// throw Exception if the tagName string contains an illegal character
	if (this.ownerDocument.implementation.errorChecking && (!this.ownerDocument.implementation._isValidName(tagName))) {
	throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
	}

	// create DOMElement specifying 'this' as ownerDocument
	var node = new DOMElement(this);

	// assign values to properties (and aliases)
	node.tagName	= tagName;
	node.nodeName = tagName;

	// add Element to 'all' collection
	this.all[this.all.length] = node;

	return node;
};

/**
 * @method DOMDocument.createDocumentFragment - CCreates an empty DocumentFragment object.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMDocumentFragment - The new DocumentFragment object
 */
DOMDocument.prototype.createDocumentFragment = function DOMDocument_createDocumentFragment() {
	// create DOMDocumentFragment specifying 'this' as ownerDocument
	var node = new DOMDocumentFragment(this);

	return node;
};

/**
 * @method DOMDocument.createTextNode - Creates a Text node given the specified string.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	data : string - The data for the node.
 *
 * @return : DOMText - The new Text object.
 */
DOMDocument.prototype.createTextNode = function DOMDocument_createTextNode(data) {
	// create DOMText specifying 'this' as ownerDocument
	var node = new DOMText(this);

	// assign values to properties (and aliases)
	node.data		= data;
	node.nodeValue = data;

	// set initial length
	node.length	= data.length;

	return node;
};

/**
 * @method DOMDocument.createComment - Creates a Text node given the specified string.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	data : string - The data for the node.
 *
 * @return : DOMComment - The new Comment object.
 */
DOMDocument.prototype.createComment = function DOMDocument_createComment(data) {
	// create DOMComment specifying 'this' as ownerDocument
	var node = new DOMComment(this);

	// assign values to properties (and aliases)
	node.data		= data;
	node.nodeValue = data;

	// set initial length
	node.length	= data.length;

	return node;
};

/**
 * @method DOMDocument.createCDATASection - Creates a CDATASection node whose value is the specified string.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	data : string - The data for the node.
 *
 * @return : DOMCDATASection - The new CDATASection object.
 */
DOMDocument.prototype.createCDATASection = function DOMDocument_createCDATASection(data) {
	// create DOMCDATASection specifying 'this' as ownerDocument
	var node = new DOMCDATASection(this);

	// assign values to properties (and aliases)
	node.data		= data;
	node.nodeValue = data;

	// set initial length
	node.length	= data.length;

	return node;
};

/**
 * @method DOMDocument.createProcessingInstruction - Creates a ProcessingInstruction node given the specified target and data strings.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	target : string - The target part of the processing instruction.
 * @param	data	 : string - The data for the node.
 *
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 *
 * @return : DOMProcessingInstruction - The new ProcessingInstruction object.
 */
DOMDocument.prototype.createProcessingInstruction = function DOMDocument_createProcessingInstruction(target, data) {
	// throw Exception if the target string contains an illegal character
	if (this.ownerDocument.implementation.errorChecking && (!this.implementation._isValidName(target))) {
	throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
	}

	// create DOMProcessingInstruction specifying 'this' as ownerDocument
	var node = new DOMProcessingInstruction(this);

	// assign values to properties (and aliases)
	node.target	= target;
	node.nodeName	= target;
	node.data		= data;
	node.nodeValue = data;

	// set initial length
	node.length	= data.length;

	return node;
};

/**
 * @method DOMDocument.createAttribute - Creates an Attr of the given name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	name : string - The name of the attribute.
 *
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 *
 * @return : DOMAttr - The new Attr object.
 */
DOMDocument.prototype.createAttribute = function DOMDocument_createAttribute(name) {
	// throw Exception if the name string contains an illegal character
	if (this.ownerDocument.implementation.errorChecking && (!this.ownerDocument.implementation._isValidName(name))) {
	throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
	}

	// create DOMAttr specifying 'this' as ownerDocument
	var node = new DOMAttr(this);

	// assign values to properties (and aliases)
	node.name	 = name;
	node.nodeName = name;

	return node;
};

/**
 * @method DOMDocument.createElementNS - Creates an element of the type specified,
 *	 within the specified namespace.
 *	 Note that the instance returned implements the Element interface,
 *	 so attributes can be specified directly on the returned object.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	namespaceURI	: string - The namespace URI of the element.
 * @param	qualifiedName : string - The qualified name of the element type to instantiate.
 *
 * @throws : DOMException - NAMESPACE_ERR: Raised if the Namespace is invalid
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 *
 * @return : DOMElement - The new Element object.
 */
DOMDocument.prototype.createElementNS = function DOMDocument_createElementNS(namespaceURI, qualifiedName) {
	// test for exceptions
	if (this.ownerDocument.implementation.errorChecking) {
	// throw Exception if the Namespace is invalid
	if (!this.ownerDocument._isValidNamespace(namespaceURI, qualifiedName)) {
		throw(new DOMException(DOMException.NAMESPACE_ERR));
	}

	// throw Exception if the qualifiedName string contains an illegal character
	if (!this.ownerDocument.implementation._isValidName(qualifiedName)) {
		throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
	}
	}

	// create DOMElement specifying 'this' as ownerDocument
	var node	= new DOMElement(this);
	var qname = this.implementation._parseQName(qualifiedName);

	// assign values to properties (and aliases)
	node.nodeName	 = qualifiedName;
	node.namespaceURI = namespaceURI;
	node.prefix		 = qname.prefix;
	node.localName	= qname.localName;
	node.tagName		= qualifiedName;

	// add Element to 'all' collection
	this.all[this.all.length] = node;

	return node;
};

/**
 * @method DOMDocument.createAttributeNS - Creates an Attr of the given name
 *	 within the specified namespace.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	namespaceURI	: string - The namespace URI of the attribute.
 * @param	qualifiedName : string - The qualified name of the attribute.
 *
 * @throws : DOMException - NAMESPACE_ERR: Raised if the Namespace is invalid
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 *
 * @return : DOMAttr - The new Attr object.
 */
DOMDocument.prototype.createAttributeNS = function DOMDocument_createAttributeNS(namespaceURI, qualifiedName) {
	// test for exceptions
	if (this.ownerDocument.implementation.errorChecking) {
	// throw Exception if the Namespace is invalid
	if (!this.ownerDocument._isValidNamespace(namespaceURI, qualifiedName, true)) {
		throw(new DOMException(DOMException.NAMESPACE_ERR));
	}

	// throw Exception if the qualifiedName string contains an illegal character
	if (!this.ownerDocument.implementation._isValidName(qualifiedName)) {
		throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
	}
	}

	// create DOMAttr specifying 'this' as ownerDocument
	var node	= new DOMAttr(this);
	var qname = this.implementation._parseQName(qualifiedName);

	// assign values to properties (and aliases)
	node.nodeName	 = qualifiedName
	node.namespaceURI = namespaceURI
	node.prefix		 = qname.prefix;
	node.localName	= qname.localName;
	node.name		 = qualifiedName
	node.nodeValue	= "";

	return node;
};

/**
 * @method DOMDocument.createNamespace - Creates an Namespace of the given name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	qualifiedName : string - The qualified name of the attribute.
 *
 * @return : DOMNamespace - The new Namespace object.
 */
DOMDocument.prototype.createNamespace = function DOMDocument_createNamespace(qualifiedName) {
	// create DOMNamespace specifying 'this' as ownerDocument
	var node	= new DOMNamespace(this);
	var qname = this.implementation._parseQName(qualifiedName);

	// assign values to properties (and aliases)
	node.nodeName	 = qualifiedName
	node.prefix		 = qname.prefix;
	node.localName	= qname.localName;
	node.name		 = qualifiedName
	node.nodeValue	= "";

	return node;
};

/**
 * @method DOMDocument.getElementById - Return the Element whose ID is given by elementId
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	elementId : string - The unique ID of the Element
 *
 * @return : DOMElement - The requested DOMElement
 */
DOMDocument.prototype.getElementById = function DOMDocument_getElementById(elementId) {
//	return this._ids[elementId];
	retNode = null;

	// loop through all Elements in the 'all' collection
	for (var i=0; i < this.all.length; i++) {
	var node = this.all[i];

	// if id matches & node is alive (ie, connected (in)directly to the documentElement)
	if ((node.id == elementId) && (node._isAncestor(node.ownerDocument.documentElement))) {
		retNode = node;
		break;
	}
	}

	return retNode;
};



/**
 * @method DOMDocument._genId - generate a unique internal id
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string - The unique (serial) id
 */
DOMDocument.prototype._genId = function DOMDocument__genId() {
	this._lastId += 1;							 // increment lastId (to generate unique id)

	return this._lastId;
};


/**
 * @method DOMDocument._isValidNamespace - test if Namespace is valid
 *	ie, not valid if;
 *	the qualifiedName is malformed, or
 *	the qualifiedName has a prefix and the namespaceURI is null, or
 *	the qualifiedName has a prefix that is "xml" and the namespaceURI is
 *	 different from "http://www.w3.org/XML/1998/namespace" [Namespaces].
 *
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 *
 * @param	namespaceURI	: string - the namespace URI
 * @param	qualifiedName : string - the QName
 * @Param	isAttribute	 : boolean - true, if the requesting node is an Attr
 *
 * @return : boolean
 */
DOMDocument.prototype._isValidNamespace = function DOMDocument__isValidNamespace(namespaceURI, qualifiedName, isAttribute) {

	if (this._performingImportNodeOperation == true) {
	//we're doing an importNode operation (or a cloneNode) - in both cases, there
	//is no need to perform any namespace checking since the nodes have to have been valid
	//to have gotten into the DOM in the first place
	return true;
	}

	var valid = true;
	// parse QName
	var qName = this.implementation._parseQName(qualifiedName);


	//only check for namespaces if we're finished parsing
	if (this._parseComplete == true) {

	// if the qualifiedName is malformed
	if (qName.localName.indexOf(":") > -1 ){
		valid = false;
	}

	if ((valid) && (!isAttribute)) {
		// if the namespaceURI is not null
		if (!namespaceURI) {
		valid = false;
		}
	}

	// if the qualifiedName has a prefix
	if ((valid) && (qName.prefix == "")) {
		valid = false;
	}

	}

	// if the qualifiedName has a prefix that is "xml" and the namespaceURI is
	//	different from "http://www.w3.org/XML/1998/namespace" [Namespaces].
	/*if ((valid) && (qName.prefix == "xml") && (namespaceURI != "http://www.w3.org/XML/1998/namespace")) {
	valid = false;
	}*/

	return valid;
}

/**
 * @method DOMDocument.toString - Serialize the document into an XML string
 *
 * @author David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMDocument.prototype.toString = function DOMDocument_toString() {
	return "" + this.childNodes;
} // end function getXML


/**
 * @class	DOMElement - By far the vast majority of objects (apart from text) that authors encounter
 *	 when traversing a document are Element nodes.
 *
 * @extends DOMNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMElement = function(ownerDocument) {
	this._class = addClass(this._class, "DOMElement");
	this.DOMNode	= DOMNode;
	this.DOMNode(ownerDocument);

	this.tagName = "";							 // The name of the element.
	this.id = "";									// the ID of the element

	this.nodeType = DOMNode.ELEMENT_NODE;
};
DOMElement.prototype = new DOMNode;

/**
 * @method DOMElement.getTagName - Java style gettor for .TagName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMElement.prototype.getTagName = function DOMElement_getTagName() {
	return this.tagName;
};

/**
 * @method DOMElement.getAttribute - Retrieves an attribute value by name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	name : string - The name of the attribute to retrieve
 *
 * @return : string - The Attr value as a string, or the empty string if that attribute does not have a specified value.
 */
DOMElement.prototype.getAttribute = function DOMElement_getAttribute(name) {
	var ret = "";

	// if attribute exists, use it
	var attr = this.attributes.getNamedItem(name);

	if (attr) {
	ret = attr.value;
	}

	return ret; // if Attribute exists, return its value, otherwise, return ""
};

/**
 * @method DOMElement.setAttribute - Retrieves an attribute value by name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	name	: string - The name of the attribute to create or alter
 * @param	value : string - Value to set in string form
 *
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if the Attribute is readonly.
 */
DOMElement.prototype.setAttribute = function DOMElement_setAttribute(name, value) {
	// if attribute exists, use it
	var attr = this.attributes.getNamedItem(name);

	if (!attr) {
	attr = this.ownerDocument.createAttribute(name);	// otherwise create it
	}

	var value = new String(value);

	// test for exceptions
	if (this.ownerDocument.implementation.errorChecking) {
	// throw Exception if Attribute is readonly
	if (attr._readonly) {
		throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// throw Exception if the value string contains an illegal character
	if (!this.ownerDocument.implementation._isValidString(value)) {
		throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
	}
	}

	if (this.ownerDocument.implementation._isIdDeclaration(name)) {
	this.id = value;	// cache ID for getElementById()
	}

	// assign values to properties (and aliases)
	attr.value	 = value;
	attr.nodeValue = value;

	// update .specified
	if (value.length > 0) {
	attr.specified = true;
	}
	else {
	attr.specified = false;
	}

	// add/replace Attribute in NamedNodeMap
	this.attributes.setNamedItem(attr);
};

/**
 * @method DOMElement.removeAttribute - Removes an attribute by name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	name	: string - The name of the attribute to remove
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if the Attrbute is readonly.
 */
DOMElement.prototype.removeAttribute = function DOMElement_removeAttribute(name) {
	// delegate to DOMNamedNodeMap.removeNamedItem
	return this.attributes.removeNamedItem(name);
};

/**
 * @method DOMElement.getAttributeNode - Retrieves an Attr node by name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	name	: string - The name of the attribute to remove
 *
 * @return : DOMAttr - The Attr node with the specified attribute name or null if there is no such attribute.
 */
DOMElement.prototype.getAttributeNode = function DOMElement_getAttributeNode(name) {
	// delegate to DOMNamedNodeMap.getNamedItem
	return this.attributes.getNamedItem(name);
};

/**
 * @method DOMElement.setAttributeNode - Adds a new attribute
 *	 If an attribute with that name is already present in the element, it is replaced by the new one
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	newAttr : DOMAttr - The attribute node to be attached
 *
 * @throws : DOMException - WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than the one that created this map.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Element is readonly.
 * @throws : DOMException - INUSE_ATTRIBUTE_ERR: Raised if arg is an Attr that is already an attribute of another Element object.
 *
 * @return : DOMAttr - If the newAttr attribute replaces an existing attribute with the same name,
 *	 the previously existing Attr node is returned, otherwise null is returned.
 */
DOMElement.prototype.setAttributeNode = function DOMElement_setAttributeNode(newAttr) {
	// if this Attribute is an ID
	if (this.ownerDocument.implementation._isIdDeclaration(newAttr.name)) {
	this.id = newAttr.value;	// cache ID for getElementById()
	}

	// delegate to DOMNamedNodeMap.setNamedItem
	return this.attributes.setNamedItem(newAttr);
};

/**
 * @method DOMElement.removeAttributeNode - Removes the specified attribute
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	oldAttr	: DOMAttr - The Attr node to remove from the attribute list
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Element is readonly.
 * @throws : DOMException - INUSE_ATTRIBUTE_ERR: Raised if arg is an Attr that is already an attribute of another Element object.
 *
 * @return : DOMAttr - The Attr node that was removed.
 */
DOMElement.prototype.removeAttributeNode = function DOMElement_removeAttributeNode(oldAttr) {
	// throw Exception if Attribute is readonly
	if (this.ownerDocument.implementation.errorChecking && oldAttr._readonly) {
	throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// get item index
	var itemIndex = this.attributes._findItemIndex(oldAttr._id);

	// throw Exception if node does not exist in this map
	if (this.ownerDocument.implementation.errorChecking && (itemIndex < 0)) {
	throw(new DOMException(DOMException.NOT_FOUND_ERR));
	}

	return this.attributes._removeChild(itemIndex);
};

/**
 * @method DOMElement.getAttributeNS - Retrieves an attribute value by namespaceURI and localName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	namespaceURI : string - the namespace URI of the required node
 * @param	localName	: string - the local name of the required node
 *
 * @return : string - The Attr value as a string, or the empty string if that attribute does not have a specified value.
 */
DOMElement.prototype.getAttributeNS = function DOMElement_getAttributeNS(namespaceURI, localName) {
	var ret = "";

	// delegate to DOMNAmedNodeMap.getNamedItemNS
	var attr = this.attributes.getNamedItemNS(namespaceURI, localName);


	if (attr) {
	ret = attr.value;
	}

	return ret;	// if Attribute exists, return its value, otherwise return ""
};

/**
 * @method DOMElement.setAttributeNS - Sets an attribute value by namespaceURI and localName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	namespaceURI : string - the namespace URI of the required node
 * @param	qualifiedName : string - the qualified name of the required node
 * @param	value		: string - Value to set in string form
 *
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if the Attrbute is readonly.
 * @throws : DOMException - NAMESPACE_ERR: Raised if the Namespace is invalid
 */
DOMElement.prototype.setAttributeNS = function DOMElement_setAttributeNS(namespaceURI, qualifiedName, value) {
	// call DOMNamedNodeMap.getNamedItem
	var attr = this.attributes.getNamedItem(namespaceURI, qualifiedName);

	if (!attr) {	// if Attribute exists, use it
	// otherwise create it
	attr = this.ownerDocument.createAttributeNS(namespaceURI, qualifiedName);
	}

	var value = new String(value);

	// test for exceptions
	if (this.ownerDocument.implementation.errorChecking) {
	// throw Exception if Attribute is readonly
	if (attr._readonly) {
		throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// throw Exception if the Namespace is invalid
	if (!this.ownerDocument._isValidNamespace(namespaceURI, qualifiedName)) {
		throw(new DOMException(DOMException.NAMESPACE_ERR));
	}

	// throw Exception if the value string contains an illegal character
	if (!this.ownerDocument.implementation._isValidString(value)) {
		throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
	}
	}

	// if this Attribute is an ID
	if (this.ownerDocument.implementation._isIdDeclaration(name)) {
	this.id = value;	// cache ID for getElementById()
	}

	// assign values to properties (and aliases)
	attr.value	 = value;
	attr.nodeValue = value;

	// update .specified
	if (value.length > 0) {
	attr.specified = true;
	}
	else {
	attr.specified = false;
	}

	// delegate to DOMNamedNodeMap.setNamedItem
	this.attributes.setNamedItemNS(attr);
};

/**
 * @method DOMElement.removeAttributeNS - Removes an attribute by namespaceURI and localName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	namespaceURI : string - the namespace URI of the required node
 * @param	localName	: string - the local name of the required node
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if the Attrbute is readonly.
 *
 * @return : DOMAttr
 */
DOMElement.prototype.removeAttributeNS = function DOMElement_removeAttributeNS(namespaceURI, localName) {
	// delegate to DOMNamedNodeMap.removeNamedItemNS
	return this.attributes.removeNamedItemNS(namespaceURI, localName);
};

/**
 * @method DOMElement.getAttributeNodeNS - Retrieves an Attr node by namespaceURI and localName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	namespaceURI : string - the namespace URI of the required node
 * @param	localName	: string - the local name of the required node
 *
 * @return : DOMAttr - The Attr node with the specified attribute name or null if there is no such attribute.
 */
DOMElement.prototype.getAttributeNodeNS = function DOMElement_getAttributeNodeNS(namespaceURI, localName) {
	// delegate to DOMNamedNodeMap.getNamedItemNS
	return this.attributes.getNamedItemNS(namespaceURI, localName);
};

/**
 * @method DOMElement.setAttributeNodeNS - Adds a new attribute
 *	 If an attribute with that name is already present in the element, it is replaced by the new one
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	newAttr		: DOMAttr - the attribute node to be attached
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if the Attrbute is readonly.
 * @throws : DOMException - WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than the one that created this map.
 * @throws : DOMException - INUSE_ATTRIBUTE_ERR: Raised if arg is an Attr that is already an attribute of another Element object.
 *	The DOM user must explicitly clone Attr nodes to re-use them in other elements.
 *
 * @return : DOMAttr - If the newAttr attribute replaces an existing attribute with the same name,
 *	 the previously existing Attr node is returned, otherwise null is returned.
 */
DOMElement.prototype.setAttributeNodeNS = function DOMElement_setAttributeNodeNS(newAttr) {
	// if this Attribute is an ID
	if ((newAttr.prefix == "") &&	this.ownerDocument.implementation._isIdDeclaration(newAttr.name)) {
	this.id = newAttr.value;	// cache ID for getElementById()
	}

	// delegate to DOMNamedNodeMap.setNamedItemNS
	return this.attributes.setNamedItemNS(newAttr);
};

/**
 * @method DOMElement.hasAttribute - Returns true if specified node exists
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	name : string - the name of the required node
 *
 * @return : boolean
 */
DOMElement.prototype.hasAttribute = function DOMElement_hasAttribute(name) {
	// delegate to DOMNamedNodeMap._hasAttribute
	return this.attributes._hasAttribute(name);
}

/**
 * @method DOMElement.hasAttributeNS - Returns true if specified node exists
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	namespaceURI : string - the namespace URI of the required node
 * @param	localName	: string - the local name of the required node
 *
 * @return : boolean
 */
DOMElement.prototype.hasAttributeNS = function DOMElement_hasAttributeNS(namespaceURI, localName) {
	// delegate to DOMNamedNodeMap._hasAttributeNS
	return this.attributes._hasAttributeNS(namespaceURI, localName);
}

/**
 * @method DOMElement.toString - Serialize this Element and its children into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMElement.prototype.toString = function DOMElement_toString() {
	var ret = "";

	// serialize namespace declarations
	var ns = this._namespaces.toString();
	if (ns.length > 0) ns = " "+ ns;

	// serialize Attribute declarations
	var attrs = this.attributes.toString();
	if (attrs.length > 0) attrs = " "+ attrs;

	// serialize this Element
	ret += "<" + this.nodeName + ns + attrs +">";
	ret += this.childNodes.toString();;
	ret += "</" + this.nodeName+">";

	return ret;
}

/**
 * @class	DOMAttr - The Attr interface represents an attribute in an Element object
 *
 * @extends DOMNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMAttr = function(ownerDocument) {
	this._class = addClass(this._class, "DOMAttr");
	this.DOMNode = DOMNode;
	this.DOMNode(ownerDocument);

	this.name		= "";							 // the name of this attribute

	// If this attribute was explicitly given a value in the original document, this is true; otherwise, it is false.
	// Note that the implementation is in charge of this attribute, not the user.
	// If the user changes the value of the attribute (even if it ends up having the same value as the default value)
	// then the specified flag is automatically flipped to true
	// (I wish! You will need to use setValue to 'automatically' update specified)
	this.specified = false;

	this.value	 = "";							 // the value of the attribute is returned as a string

	this.nodeType	= DOMNode.ATTRIBUTE_NODE;

	this.ownerElement = null;						// set when Attr is added to NamedNodeMap

	// disable childNodes
	this.childNodes = null;
	this.attributes = null;
};
DOMAttr.prototype = new DOMNode;

/**
 * @method DOMAttr.getName - Java style gettor for .name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMAttr.prototype.getName = function DOMAttr_getName() {
	return this.nodeName;
};

/**
 * @method DOMAttr.getSpecified - Java style gettor for .specified
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : boolean
 */
DOMAttr.prototype.getSpecified = function DOMAttr_getSpecified() {
	return this.specified;
};

/**
 * @method DOMAttr.getValue - Java style gettor for .value
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMAttr.prototype.getValue = function DOMAttr_getValue() {
	return this.nodeValue;
};

/**
 * @method DOMAttr.setValue - Java style settor for .value
 *	 alias for DOMAttr.setNodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	value : string - the new attribute value
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Attribute is readonly.
 */
DOMAttr.prototype.setValue = function DOMAttr_setValue(value) {
	// throw Exception if Attribute is readonly
	if (this.ownerDocument.implementation.errorChecking && this._readonly) {
	throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// delegate to setNodeValue
	this.setNodeValue(value);
};

/**
 * @method DOMAttr.setNodeValue - Java style settor for .nodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	value : string - the new attribute value
 */
DOMAttr.prototype.setNodeValue = function DOMAttr_setNodeValue(value) {
	this.nodeValue = new String(value);
	this.value	 = this.nodeValue;
	this.specified = (this.value.length > 0);
};

/**
 * @method DOMAttr.toString - Serialize this Attr into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMAttr.prototype.toString = function DOMAttr_toString() {
	var ret = "";

	// serialize Attribute
	ret += this.nodeName +"=\""+ this.__escapeString(this.nodeValue) +"\"";

	return ret;
}

DOMAttr.prototype.getOwnerElement = function() {

	return this.ownerElement;

}

/**
 * @class	DOMNamespace - The Namespace interface represents an namespace in an Element object
 *
 * @extends DOMNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMNamespace = function(ownerDocument) {
	this._class = addClass(this._class, "DOMNamespace");
	this.DOMNode = DOMNode;
	this.DOMNode(ownerDocument);

	this.name		= "";							 // the name of this attribute

	// If this attribute was explicitly given a value in the original document, this is true; otherwise, it is false.
	// Note that the implementation is in charge of this attribute, not the user.
	// If the user changes the value of the attribute (even if it ends up having the same value as the default value)
	// then the specified flag is automatically flipped to true
	// (I wish! You will need to use _setValue to 'automatically' update specified)
	this.specified = false;

	this.value	 = "";							 // the value of the attribute is returned as a string

	this.nodeType	= DOMNode.NAMESPACE_NODE;
};
DOMNamespace.prototype = new DOMNode;

/**
 * @method DOMNamespace.getValue - Java style gettor for .value
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMNamespace.prototype.getValue = function DOMNamespace_getValue() {
	return this.nodeValue;
};

/**
 * @method DOMNamespace.setValue - utility function to set value (rather than direct assignment to .value)
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	value : string - the new namespace value
 */
DOMNamespace.prototype.setValue = function DOMNamespace_setValue(value) {
	// assign values to properties (and aliases)
	this.nodeValue = new String(value);
	this.value	 = this.nodeValue;
};

/**
 * @method DOMNamespace.toString - Serialize this Attr into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMNamespace.prototype.toString = function DOMNamespace_toString() {
	var ret = "";

	// serialize Namespace Declaration
	if (this.nodeName != "") {
	ret += this.nodeName +"=\""+ this.__escapeString(this.nodeValue) +"\"";
	}
	else {	// handle default namespace
	ret += "xmlns=\""+ this.__escapeString(this.nodeValue) +"\"";
	}

	return ret;
}

/**
 * @class	DOMCharacterData - parent abstract class for DOMText and DOMComment
 *
 * @extends DOMNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMCharacterData = function(ownerDocument) {
	this._class = addClass(this._class, "DOMCharacterData");
	this.DOMNode	= DOMNode;
	this.DOMNode(ownerDocument);

	this.data	 = "";
	this.length = 0;
};
DOMCharacterData.prototype = new DOMNode;

/**
 * @method DOMCharacterData.getData - Java style gettor for .data
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMCharacterData.prototype.getData = function DOMCharacterData_getData() {
	return this.nodeValue;
};

/**
 * @method DOMCharacterData.setData - Java style settor for .data
 *	alias for DOMCharacterData.setNodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	data : string - the character data
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Attribute is readonly.
 */
DOMCharacterData.prototype.setData = function DOMCharacterData_setData(data) {
	// delegate to setNodeValue
	this.setNodeValue(data);
};

/**
 * @method DOMCharacterData.setNodeValue - Java style settor for .nodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	data : string - the node value
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Attribute is readonly.
 */
DOMCharacterData.prototype.setNodeValue = function DOMCharacterData_setNodeValue(data) {
	// throw Exception if Attribute is readonly
	if (this.ownerDocument.implementation.errorChecking && this._readonly) {
	throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// assign values to properties (and aliases)
	this.nodeValue = new String(data);
	this.data	 = this.nodeValue;

	// update length
	this.length = this.nodeValue.length;
};

/**
 * @method DOMCharacterData.getLength - Java style gettor for .length
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMCharacterData.prototype.getLength = function DOMCharacterData_getLength() {
	return this.nodeValue.length;
};

/**
 * @method DOMCharacterData.substringData - Extracts a range of data from the node
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	offset : int - Start offset of substring to extract
 * @param	count	: int - The number of characters to extract
 *
 * @throws : DOMException - INDEX_SIZE_ERR: Raised if specified offset is negative or greater than the number of 16-bit units in data,
 *
 * @return : string - The specified substring.
 *	 If the sum of offset and count exceeds the length, then all characters to the end of the data are returned.
 */
DOMCharacterData.prototype.substringData = function DOMCharacterData_substringData(offset, count) {
	var ret = null;

	if (this.data) {
	// throw Exception if offset is negative or greater than the data length,
	// or the count is negative
	if (this.ownerDocument.implementation.errorChecking && ((offset < 0) || (offset > this.data.length) || (count < 0))) {
		throw(new DOMException(DOMException.INDEX_SIZE_ERR));
	}

	// if count is not specified
	if (!count) {
		ret = this.data.substring(offset); // default to 'end of string'
	}
	else {
		ret = this.data.substring(offset, offset + count);
	}
	}

	return ret;
};

/**
 * @method DOMCharacterData.appendData - Append the string to the end of the character data of the node.
 *	 Upon success, data provides access to the concatenation of data and the DOMString specified.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	arg : string - The string to append
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this CharacterData is readonly.
 */
DOMCharacterData.prototype.appendData	= function DOMCharacterData_appendData(arg) {
	// throw Exception if DOMCharacterData is readonly
	if (this.ownerDocument.implementation.errorChecking && this._readonly) {
	throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// append data
	this.setData(""+ this.data + arg);
};

/**
 * @method DOMCharacterData.insertData - Insert a string at the specified character offset.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	offset : int	- The character offset at which to insert
 * @param	arg	: string - The string to insert
 *
 * @throws : DOMException - INDEX_SIZE_ERR: Raised if specified offset is negative or greater than the number of 16-bit units in data,
 *	 or if the specified count is negative.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this CharacterData is readonly.
 */
DOMCharacterData.prototype.insertData	= function DOMCharacterData_insertData(offset, arg) {
	// throw Exception if DOMCharacterData is readonly
	if (this.ownerDocument.implementation.errorChecking && this._readonly) {
	throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	if (this.data) {
	// throw Exception if offset is negative or greater than the data length,
	if (this.ownerDocument.implementation.errorChecking && ((offset < 0) || (offset >	this.data.length))) {
		throw(new DOMException(DOMException.INDEX_SIZE_ERR));
	}

	// insert data
	this.setData(this.data.substring(0, offset).concat(arg, this.data.substring(offset)));
	}
	else {
	// throw Exception if offset is negative or greater than the data length,
	if (this.ownerDocument.implementation.errorChecking && (offset != 0)) {
		throw(new DOMException(DOMException.INDEX_SIZE_ERR));
	}

	// set data
	this.setData(arg);
	}
};

/**
 * @method DOMCharacterData.deleteData - Remove a range of characters from the node.
 *	 Upon success, data and length reflect the change
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	offset : int - The offset from which to remove characters
 * @param	count	: int - The number of characters to delete.
 *	 If the sum of offset and count exceeds length then all characters from offset to the end of the data are deleted
 *
 * @throws : DOMException - INDEX_SIZE_ERR: Raised if specified offset is negative or greater than the number of 16-bit units in data,
 *	 or if the specified count is negative.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this CharacterData is readonly.
 */
DOMCharacterData.prototype.deleteData	= function DOMCharacterData_deleteData(offset, count) {
	// throw Exception if DOMCharacterData is readonly
	if (this.ownerDocument.implementation.errorChecking && this._readonly) {
	throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	if (this.data) {
	// throw Exception if offset is negative or greater than the data length,
	if (this.ownerDocument.implementation.errorChecking && ((offset < 0) || (offset >	this.data.length) || (count < 0))) {
		throw(new DOMException(DOMException.INDEX_SIZE_ERR));
	}

	// delete data
	if(!count || (offset + count) > this.data.length) {
		this.setData(this.data.substring(0, offset));
	}
	else {
		this.setData(this.data.substring(0, offset).concat(this.data.substring(offset + count)));
	}
	}
};

/**
 * @method DOMCharacterData.replaceData - Replace the characters starting at the specified character offset with the specified string
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	offset : int	- The offset from which to start replacing
 * @param	count	: int	- The number of characters to replace.
 *	 If the sum of offset and count exceeds length, then all characters to the end of the data are replaced
 * @param	arg	: string - The string with which the range must be replaced
 *
 * @throws : DOMException - INDEX_SIZE_ERR: Raised if specified offset is negative or greater than the number of 16-bit units in data,
 *	 or if the specified count is negative.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this CharacterData is readonly.
 */
DOMCharacterData.prototype.replaceData	 = function DOMCharacterData_replaceData(offset, count, arg) {
	// throw Exception if DOMCharacterData is readonly
	if (this.ownerDocument.implementation.errorChecking && this._readonly) {
	throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	if (this.data) {
	// throw Exception if offset is negative or greater than the data length,
	if (this.ownerDocument.implementation.errorChecking && ((offset < 0) || (offset >	this.data.length) || (count < 0))) {
		throw(new DOMException(DOMException.INDEX_SIZE_ERR));
	}

	// replace data
	this.setData(this.data.substring(0, offset).concat(arg, this.data.substring(offset + count)));
	}
	else {
	// set data
	this.setData(arg);
	}
};

/**
 * @class	DOMText - The Text interface represents the textual content (termed character data in XML) of an Element or Attr.
 *	 If there is no markup inside an element's content, the text is contained in a single object implementing the Text interface
 *	 that is the only child of the element. If there is markup, it is parsed into a list of elements and Text nodes that form the
 *	 list of children of the element.
 *
 * @extends DOMCharacterData
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMText = function(ownerDocument) {
	this._class = addClass(this._class, "DOMText");
	this.DOMCharacterData	= DOMCharacterData;
	this.DOMCharacterData(ownerDocument);

	this.nodeName	= "#text";
	this.nodeType	= DOMNode.TEXT_NODE;
};
DOMText.prototype = new DOMCharacterData;

/**
 * @method DOMText.splitText - Breaks this Text node into two Text nodes at the specified offset,
 *	 keeping both in the tree as siblings. This node then only contains all the content up to the offset point.
 *	 And a new Text node, which is inserted as the next sibling of this node, contains all the content at and after the offset point.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	offset : int - The offset at which to split, starting from 0.
 *
 * @throws : DOMException - INDEX_SIZE_ERR: Raised if specified offset is negative or greater than the number of 16-bit units in data,
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Text is readonly.
 *
 * @return : DOMText - The new Text node
 */
DOMText.prototype.splitText = function DOMText_splitText(offset) {
	var data, inode;

	// test for exceptions
	if (this.ownerDocument.implementation.errorChecking) {
	// throw Exception if Node is readonly
	if (this._readonly) {
		throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// throw Exception if offset is negative or greater than the data length,
	if ((offset < 0) || (offset > this.data.length)) {
		throw(new DOMException(DOMException.INDEX_SIZE_ERR));
	}
	}

	if (this.parentNode) {
	// get remaining string (after offset)
	data	= this.substringData(offset);

	// create new TextNode with remaining string
	inode = this.ownerDocument.createTextNode(data);

	// attach new TextNode
	if (this.nextSibling) {
		this.parentNode.insertBefore(inode, this.nextSibling);
	}
	else {
		this.parentNode.appendChild(inode);
	}

	// remove remaining string from original TextNode
	this.deleteData(offset);
	}

	return inode;
};

/**
 * @method DOMText.toString - Serialize this Text into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMText.prototype.toString = function DOMText_toString() {
	return this.__escapeString(""+ this.nodeValue);
}

/**
 * @class	DOMCDATASection - CDATA sections are used to escape blocks of text containing characters that would otherwise be regarded as markup.
 *	 The only delimiter that is recognized in a CDATA section is the "\]\]\>" string that ends the CDATA section
 *
 * @extends DOMCharacterData
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMCDATASection = function(ownerDocument) {
	this._class = addClass(this._class, "DOMCDATASection");
	this.DOMCharacterData	= DOMCharacterData;
	this.DOMCharacterData(ownerDocument);

	this.nodeName	= "#cdata-section";
	this.nodeType	= DOMNode.CDATA_SECTION_NODE;
};
DOMCDATASection.prototype = new DOMCharacterData;

/**
 * @method DOMCDATASection.splitText - Breaks this CDATASection node into two CDATASection nodes at the specified offset,
 *	 keeping both in the tree as siblings. This node then only contains all the content up to the offset point.
 *	 And a new CDATASection node, which is inserted as the next sibling of this node, contains all the content at and after the offset point.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	offset : int - The offset at which to split, starting from 0.
 *
 * @return : DOMCDATASection - The new CDATASection node
 */
DOMCDATASection.prototype.splitText = function DOMCDATASection_splitText(offset) {
	var data, inode;

	// test for exceptions
	if (this.ownerDocument.implementation.errorChecking) {
	// throw Exception if Node is readonly
	if (this._readonly) {
		throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// throw Exception if offset is negative or greater than the data length,
	if ((offset < 0) || (offset > this.data.length)) {
		throw(new DOMException(DOMException.INDEX_SIZE_ERR));
	}
	}

	if(this.parentNode) {
	// get remaining string (after offset)
	data	= this.substringData(offset);

	// create new CDATANode with remaining string
	inode = this.ownerDocument.createCDATASection(data);

	// attach new CDATANode
	if (this.nextSibling) {
		this.parentNode.insertBefore(inode, this.nextSibling);
	}
	else {
		this.parentNode.appendChild(inode);
	}

	 // remove remaining string from original CDATANode
	this.deleteData(offset);
	}

	return inode;
};

/**
 * @method DOMCDATASection.toString - Serialize this CDATASection into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMCDATASection.prototype.toString = function DOMCDATASection_toString() {
	var ret = "";
	//do NOT unescape the nodeValue string in CDATA sections!
	ret += "<![CDATA[" + this.nodeValue + "\]\]\>";

	return ret;
}

/**
 * @class	DOMComment - This represents the content of a comment, i.e., all the characters between the starting '<!--' and ending '-->'
 *
 * @extends DOMCharacterData
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMComment = function(ownerDocument) {
	this._class = addClass(this._class, "DOMComment");
	this.DOMCharacterData	= DOMCharacterData;
	this.DOMCharacterData(ownerDocument);

	this.nodeName	= "#comment";
	this.nodeType	= DOMNode.COMMENT_NODE;
};
DOMComment.prototype = new DOMCharacterData;

/**
 * @method DOMComment.toString - Serialize this Comment into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMComment.prototype.toString = function DOMComment_toString() {
	var ret = "";

	ret += "<!--" + this.nodeValue + "-->";

	return ret;
}

/**
 * @class	DOMProcessingInstruction - The ProcessingInstruction interface represents a "processing instruction",
 *	 used in XML as a way to keep processor-specific information in the text of the document
 *
 * @extends DOMNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMProcessingInstruction = function(ownerDocument) {
	this._class = addClass(this._class, "DOMProcessingInstruction");
	this.DOMNode	= DOMNode;
	this.DOMNode(ownerDocument);

	// The target of this processing instruction.
	// XML defines this as being the first token following the markup that begins the processing instruction.
	this.target = "";

	// The content of this processing instruction.
	// This is from the first non white space character after the target to the character immediately preceding the ?>
	this.data	 = "";

	this.nodeType	= DOMNode.PROCESSING_INSTRUCTION_NODE;
};
DOMProcessingInstruction.prototype = new DOMNode;

/**
 * @method DOMProcessingInstruction.getTarget - Java style gettor for .target
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMProcessingInstruction.prototype.getTarget = function DOMProcessingInstruction_getTarget() {
	return this.nodeName;
};

/**
 * @method DOMProcessingInstruction.getData - Java style gettor for .data
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMProcessingInstruction.prototype.getData = function DOMProcessingInstruction_getData() {
	return this.nodeValue;
};

/**
 * @method DOMProcessingInstruction.setData - Java style settor for .data
 *	 alias for DOMProcessingInstruction.setNodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	data : string - The new data of this processing instruction.
 */
DOMProcessingInstruction.prototype.setData = function DOMProcessingInstruction_setData(data) {
	// delegate to setNodeValue
	this.setNodeValue(data);
};

/**
 * @method DOMProcessingInstruction.setNodeValue - Java style settor for .nodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	data : string - The new data of this processing instruction.
 */
DOMProcessingInstruction.prototype.setNodeValue = function DOMProcessingInstruction_setNodeValue(data) {
	// throw Exception if DOMNode is readonly
	if (this.ownerDocument.implementation.errorChecking && this._readonly) {
	throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
	}

	// assign values to properties (and aliases)
	this.nodeValue = new String(data);
	this.data = this.nodeValue;
};

/**
 * @method DOMProcessingInstruction.toString - Serialize this ProcessingInstruction into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMProcessingInstruction.prototype.toString = function DOMProcessingInstruction_toString() {
	var ret = "";

	ret += "<?" + this.nodeName +" "+ this.nodeValue + " ?>";

	return ret;
}

/**
 * @class	DOMDocumentFragment - DocumentFragment is a "lightweight" or "minimal" Document object.
 *
 * @extends DOMNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param	ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMDocumentFragment = function(ownerDocument) {
	this._class = addClass(this._class, "DOMDocumentFragment");
	this.DOMNode = DOMNode;
	this.DOMNode(ownerDocument);

	this.nodeName	= "#document-fragment";
	this.nodeType = DOMNode.DOCUMENT_FRAGMENT_NODE;
};
DOMDocumentFragment.prototype = new DOMNode;

/**
 * @method DOMDocumentFragment.toString - Serialize this DocumentFragment into an XML string
 *
 * @author David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMDocumentFragment.prototype.toString = function DOMDocumentFragment_toString() {
	var xml = "";
	var intCount = this.getChildNodes().getLength();

	// create string concatenating the serialized ChildNodes
	for (intLoop = 0; intLoop < intCount; intLoop++) {
	xml += this.getChildNodes().item(intLoop).toString();
	}

	return xml;
}

///////////////////////
//	NOT IMPLEMENTED	//
///////////////////////
DOMDocumentType	= function() { alert("DOMDocumentType.constructor(): Not Implemented"	 ); };
DOMEntity			= function() { alert("DOMEntity.constructor(): Not Implemented"		 ); };
DOMEntityReference = function() { alert("DOMEntityReference.constructor(): Not Implemented"); };
DOMNotation		= function() { alert("DOMNotation.constructor(): Not Implemented"		 ); };


Strings = new Object()
Strings.WHITESPACE = " \t\n\r";
Strings.QUOTES = "\"'";

Strings.isEmpty = function Strings_isEmpty(strD) {
	return (strD == null) || (strD.length == 0);
};
Strings.indexOfNonWhitespace = function Strings_indexOfNonWhitespace(strD, iB, iE) {
	if(Strings.isEmpty(strD)) return -1;
	iB = iB || 0;
	iE = iE || strD.length;

	for(var i = iB; i < iE; i++)
	if(Strings.WHITESPACE.indexOf(strD.charAt(i)) == -1) {
		return i;
	}
	return -1;
};
Strings.lastIndexOfNonWhitespace = function Strings_lastIndexOfNonWhitespace(strD, iB, iE) {
	if(Strings.isEmpty(strD)) return -1;
	iB = iB || 0;
	iE = iE || strD.length;

	for(var i = iE - 1; i >= iB; i--)
	if(Strings.WHITESPACE.indexOf(strD.charAt(i)) == -1)
		return i;
	return -1;
};
Strings.indexOfWhitespace = function Strings_indexOfWhitespace(strD, iB, iE) {
	if(Strings.isEmpty(strD)) return -1;
	iB = iB || 0;
	iE = iE || strD.length;

	for(var i = iB; i < iE; i++)
	if(Strings.WHITESPACE.indexOf(strD.charAt(i)) != -1)
		return i;
	return -1;
};
Strings.replace = function Strings_replace(strD, iB, iE, strF, strR) {
	if(Strings.isEmpty(strD)) return "";
	iB = iB || 0;
	iE = iE || strD.length;

	return strD.substring(iB, iE).split(strF).join(strR);
};
Strings.getLineNumber = function Strings_getLineNumber(strD, iP) {
	if(Strings.isEmpty(strD)) return -1;
	iP = iP || strD.length;

	return strD.substring(0, iP).split("\n").length
};
Strings.getColumnNumber = function Strings_getColumnNumber(strD, iP) {
	if(Strings.isEmpty(strD)) return -1;
	iP = iP || strD.length;

	var arrD = strD.substring(0, iP).split("\n");
	var strLine = arrD[arrD.length - 1];
	arrD.length--;
	var iLinePos = arrD.join("\n").length;

	return iP - iLinePos;
};


StringBuffer = function() {this._a=new Array();};
StringBuffer.prototype.append = function StringBuffer_append(d){this._a[this._a.length]=d;};
StringBuffer.prototype.toString = function StringBuffer_toString(){return this._a.join("");};

/**
 * Remove any text nodes that belong directly to this node (not 
 * children) and set text content. A more appropriate thing to do 
 * may be to remove all children.
 *
 * @param {String} text
 */
DOMElement.prototype.setTextContent = function(text) {

	var removeIdx = [];

	// get a list of nodes to remove
	for( var i = 0; i < this.childNodes.getLength(); i++ ) {
		var node = this.childNodes.item(i);

		if( node.nodeType == DOMNode.TEXT_NODE ) {
			removeIdx.push( i );
		}
	}

	// remove them
	for( var i = 0; i < removeIdx.length; i++ ) {
		var node = this.childNodes.item(removeIdx[i]);

		this.removeChild( node );
	}

	var textNode = this.ownerDocument.createTextNode( text );
	textNode = this.appendChild( textNode );

	return textNode;
}
// =========================================================================
//
// xmlEscape.js - api for the xmlEscape functions
//
// version 3.1
//
// =========================================================================
//
// Copyright (C) 2000 - 2002 Michael Houghton (mike@idle.org) and David Joham (djoham@yahoo.com)
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.

// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
// Lesser General Public License for more details.

// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA	02111-1307	USA
//

function xmlEscapeXMLToHTML(xmlData) {
	/*************************************************************************************
	Function:		 xmlEscapeXMLToHTML

	author:		 xwisdom@yahoo.com

	description:
		Encodes XML data for use in a web page

	************************************************************************************/
	var gt; 

	var str = xmlData;

	//replace < with &lt;
	gt = -1;
	while (str.indexOf("<", gt + 1) > -1) {
		var gt = str.indexOf("<", gt + 1);
		var newStr = str.substr(0, gt);
		newStr += "&lt;";
		newStr = newStr + str.substr(gt + 1, str.length);
		str = newStr;
	}

	//replace > with &gt;
	gt = -1;
	while (str.indexOf(">", gt + 1) > -1) {
		var gt = str.indexOf(">", gt + 1);
		var newStr = str.substr(0, gt);
		newStr += "&gt;";
		newStr = newStr + str.substr(gt + 1, str.length);
		str = newStr;
	}

	//replace & with &amp;
	gt = -1;
	while (str.indexOf("&", gt + 1) > -1) {
		var gt = str.indexOf("&", gt + 1);
		var newStr = str.substr(0, gt);
		newStr += "&amp;";
		newStr = newStr + str.substr(gt + 1, str.length);
		str = newStr;
	}

	return str

}	// end function xmlEscapeXMLToHTML


function xmlUnescapeHTMLToXML(xmlData)	{
	/*************************************************************************************
	Function:		 xmlUnescapeHTMLToXML

	author:		 xwisdom@yahoo.com

	description:
		Decodes XML previously encoded with xmlEscapeXMLToHTML

	************************************************************************************/
	var str = xmlData;

	var gt;

	//replace � with <
	gt = -1;
	while (str.indexOf("�", gt + 1) > -1) {
		var gt = str.indexOf("�", gt + 1);
		var newStr = str.substr(0, gt);
		newStr += "<";
		newStr = newStr + str.substr(gt + 1, str.length);
		str = newStr;
	}


	//replace � with >
	gt = -1;
	while (str.indexOf("�", gt + 1) > -1) {
		var gt = str.indexOf("�", gt + 1);
		var newStr = str.substr(0, gt);
		newStr += ">";
		newStr = newStr + str.substr(gt + 1, str.length);
		str = newStr;
	}

	//replace � with &
	gt = -1;
	while (str.indexOf("�", gt + 1) > -1) {
		var gt = str.indexOf("�", gt + 1);
		var newStr = str.substr(0, gt);
		newStr += "&";
		newStr = newStr + str.substr(gt + 1, str.length);
		str = newStr;
	}

	return str

}// end function xmlUnescapeHTMLToXML

// =========================================================================
//
// xmlIO.js - api for the xmlIO functions
//
// version 3.1 
//
// =========================================================================
//
// Copyright (C) 2002 - 2003 David Joham (djoham@yahoo.com)
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.

// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
// Lesser General Public License for more details.

// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA	02111-1307	USA

//NOTE: parts of this code were inspired by the book JavaScript Unleashed by R. Allen Wyke, Richard Wagner

//NOTE: parts of this code were inspired by http://developer.apple.com/internet/javascript/iframe.html


//NOTE: Part of this code was written on Feb 1, 2003 after I had learned of the destruction of the space shuttle Columbia.
//		My heart goes out to the families of the seven brave astronauts: 
//		Colonel Rick Husband, Lieutenant Colonel Michael Anderson, Commander Laurel Clark, Captain David Brown, 
//		Commander William McCool, Dr. Kalpana Chawla, and Colonel Ilan Ramon of the Israeli air force. 
//		May they rest in peace.

//		Hail Mary, full of grace. The Lord is with thee. 
//		Blessed art thou amongst women, and blessed is the fruit of thy womb, Jesus.
// 		Holy Mary, Mother of God, pray for us sinners,
//		now and at the hour of our death.
//		Amen
//
//		In memory of STS-107


var _xmlIOProxyGetLastLoadStatus = "";
var _xmlIOLoadLocalDataCallbackFunction = "";
var _xmlIOLoadlocalDataIFrameID = "";
var _xmlIOLoadLocalDataLastLoadStatus = "";
var _xmlIOLoadLocalDataRetryCount = 0;

/************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************
						SAVING DATA TO THE CLIENTS HARD DRIVE VIA COOKES
*************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************/						


function xmlIODeleteData(dataName) {
	/********************************************************************************
	Function: xmlIODeleteData

	Author: djoham@yahoo.com

	Description:
		Deletes the data from the cookie stream
	********************************************************************************/
	//in order to ensure that the xmlIOGetData doesn't confuse this name with another,
	//(ie having two names like "xml1" and "xml10", 
	//the save routine wraped the name with colons. We must do the same
	dataName = ":::" + dataName + ":::";

	//expire by setting to date in past
	var expDate = new Date("January 01, 1980").toGMTString();
	document.cookie = dataName + "=;expires=" + expDate;


} // end function xmlIODeleteData


function xmlIOGetData(dataName){
	/********************************************************************************
	Function: xmlIOGetData

	Author: djoham@yahoo.com

	Description:
		retrieves the data from the cookie (if the data is there)
	********************************************************************************/

	//in order to ensure that the xmlIOGetData doesn't confuse this name with another,
	//(ie having two names like "xml1" and "xml10", 
	//the save routine wraped the name with colons. We must do the same
	var origDataName = dataName;
	dataName = ":::" + dataName + ":::";

	var myCookie = " " + document.cookie + ";";
	var cookieName = " " + dataName;
	var cookieStart = myCookie.indexOf(cookieName);
	var cookieEnd;
	var retVal = "";

	if (cookieStart != -1){
		cookieStart += cookieName.length;
		cookieEnd = myCookie.indexOf(";", cookieStart);
		retVal = unescape(myCookie.substring((cookieStart+1), cookieEnd));
	}

	//if the return value is "", it's possible that the user has upgraded from XML for <SCRIPT> 2.0 to 2.1.
	//we need to check to see if that's the case and handle the request correctly
	//xml for <SCRIPT> used String.fromCharCode(171) and String.fromCharCode(187) as delimiters
	//rather than ":::". I'll just check for String.fromCharCode(171). If it's there, it's worth doing the lookup again.
	if (retVal == "" && document.cookie.indexOf(String.fromCharCode(171)) > -1) {
		//do the lookup again, this time with the old 2.0 delimiters
		dataName = String.fromCharCode(171) + origDataName + String.fromCharCode(187);

		var myCookie = " " + document.cookie + ";";
		var cookieName = " " + dataName;
		var cookieStart = myCookie.indexOf(cookieName);
		var cookieEnd;
		if (cookieStart != -1){
			cookieStart += cookieName.length;
			cookieEnd = myCookie.indexOf(";", cookieStart);
		}

		var retVal = unescape(myCookie.substring((cookieStart+1), cookieEnd));
	}

	return retVal;

}	// end function xmlIOGetData

function xmlIOListSavedDataNames(){
	/********************************************************************************
	Function: xmlIOListSavedDataNames

	Author: djoham@yahoo.com

	Description:
		Returns an array of all the stored names in the XMLIO cookie database
	********************************************************************************/
	var aryRet = new Array();

	var arySplit = document.cookie.split(":::");
	var intCount = arySplit.length;
	for (intLoop = 0; intLoop < intCount; intLoop ++) {
		//if the split array element is empty or has an equal sign in it, we want to discard it
		if (arySplit[intLoop].indexOf("=") > -1 || arySplit[intLoop] == "") {
			//do nothing
		}
		else {
			//add it to the return array
			aryRet[aryRet.length] = arySplit[intLoop];
		}
	}

	return aryRet;

} // end xmlIOListSavedDataNames


function xmlIOSaveData(dataName, dataValue, expireDate){
	/********************************************************************************
	Function: xmlIOSaveData

	Author: djoham@yahoo.com

	Description:
		Saves the data to the cookie.

	expireDate is optional. If passed in, it must be a valid JavaScript
	Date object. If not passed in, the cookie will expire on Jan 1st
	10 years from when the function was called.
	********************************************************************************/

	var expireDateGMT; // cookies need GMT values for their expiration date

	//check if expireDate has been passed in
	if (expireDate == null) {
		var x = new Date();	//today
		var z = x.getFullYear() + 10;	//plus 10 years
		var y = new Date("January 01, " + z);	// on Jan1
		expireDateGMT = y.toGMTString();
	}
	else {
		expireDateGMT = expireDate.toGMTString();
	}

	//in order to ensure that the xmlIOGetData doesn't confuse this name with another, 
	//(ie having two names like "xml1" and "xml10", wrap the name with colons
	dataName = ":::" + dataName + ":::";

	//set the cookie
	//document.cookie = dataName + "=" + escape(dataValue) + " ;expires=" + expireDateGMT;
	document.cookie = dataName + "=" + escape(dataValue) + " ;expires=" + expireDateGMT;

}	// end function xmlIOSaveData



/************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************
						LOADING XML VIA THE PROXY SERVERS
*************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************/


function xmlIOProxyGetLastLoadStatus() {
	/********************************************************************************
	Function: xmlIOProxyGetLastLoadStatus

	Author: djoham@yahoo.com

	Description:
			Returns xmlIOProxyGetLastLoadStatus, the last status report as reported
			in the getXMLfromIframe function
	********************************************************************************/

	return _xmlIOProxyGetLastLoadStatus;


} // end xmlIOLoadXMLGetLastStatus


function xmlIOProxyLoadData(proxyURL, resourceID, callbackFunction, authenticationCode) {
	/********************************************************************************
	Function: xmlIOProxyLoadData

	Author: djoham@yahoo.com

	Description:
		makes the call to the proxy server (proxyURL) to get the XML requested (resourceID)
		and calls	the xmlIO function that reads the XML and returns it to the
		callback function (callBackFunc)
	********************************************************************************/

	var dataSource = document.createElement("iframe");
	var guid = "guid" + new Date().getTime();
	dataSource.id = guid;
	dataSource.src = __trim(proxyURL, true, true) + "?resourceID=" + resourceID + "&guid=" + guid + "&callbackFunction=" + callbackFunction + "&authenticationCode=" + authenticationCode;
	dataSource.style.position = "absolute";
	dataSource.style.left = "-2000px";

	document.body.appendChild(dataSource);
	return guid;

} //end function xmlIOProxyLoadData


function __getXMLFromIFrame(callbackGUID, callbackFunction, proxyReturnCode, xml) {
	/********************************************************************************
	Function: __getXMLFromIFrame

	Author: djoham@yahoo.com

	Description:
		Gets called when the Iframe is finished loading. Unescapes the XML
		and calls the callback function 
	********************************************************************************/

	var retXML = "";
	//clean up our mess from adding the IFRAMES
	try {
		document.body.removeChild(document.getElementById(callbackGUID));
	}
	catch (e) {
		//noop
	}

	try {
		//The retXML is escaped. use the XML for <SCRIPT>'s unescape function.
		//Put the catch in here to make sure the programmer has included it
		retXML = xmlUnescapeHTMLToXML(xml)
	}
	catch (e) {
		retXML = "The function xmlUnescapeHTMLToXML was not found. Did you include xmlEscape.js (from the jsTools directory) in your HTML file?";
		proxyReturnCode = "error";

	}

	//if the callback function is an empty string, the try-catch doesn't seem to work
	//the javascript just goes off into the weeds and never comes back
	if (callbackFunction == "") { 
		//in this case, the retXML gives a decent error string, so use it
		alert("xmlIO error in __getXMLFromIFrame:\nErrorString: " + retXML + "\nguid: " + callbackGUID + "\ncallbackFunction: " + callbackFunction + "\nproxyReturnCode: " + proxyReturnCode);
	}
	else {	
		// try to call the callback function. If it fails, punt and just set the status
		try {
			_xmlIOProxyGetLastLoadStatus = "xmlIOProxyLoadData-Called callbackFunction"; // must be before the following line
			eval(callbackFunction + "(retXML, callbackGUID, proxyReturnCode)");
		}
		catch (e) {
			_xmlIOProxyGetLastLoadStatus = "xmlIOProxyLoadData-Error: xmlIO error in __getXMLFromIFrame:\nErrorString: " + e.toString() + "\nguid: " + callbackGUID + "\ncallbackFunction: " + callbackFunction + "\nproxyReturnCode: " + proxyReturnCode;
		}
	}
} // end function __getXMLFromIFrame




/************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************
						LOADING XML VIA LOCAL FILE ACCESS
		 (files on the same web server or files on the local hard drive)
*************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************/

function xmlIOLoadLocalData(dataURL, callbackFunction) {
	/********************************************************************************
	Function: xmlIOLoadLocalData

	Author: djoham@yahoo.com

	Description:
			Loads up an IFRAME in the background with its src being dataURL
			then goes through an enourmous amount of stupid gymnastics to make
			sure it gets that data back to the calling javascript
	********************************************************************************/

	_xmlIOLoadLocalDataCallbackFunction = callbackFunction;
	_xmlIOLoadLocalDataLastLoadStatus = "Starting xmlIOLoadLocalData";
	var _xmlIOLoadLocalDataRetryCount = 0;

	//create the IFrame and start the loading process
	var dataFrame;
	try {
		try {
			dataFrame = document.createElement("iframe");
			//dataFrame.src has to be here for konq 3.0x to work properly
			dataFrame.src = dataURL;
			dataFrame.id = new Date().valueOf();
			dataFrame.style.position = "absolute";
			dataFrame.style.left = "-2000px";
			_xmlIOLoadlocalDataIFrameID = dataFrame.id;
			document.body.appendChild(dataFrame);
		}
		catch (e) {
			_xmlIOLoadLocalDataLastLoadStatus = "ERROR: xmlIOLoadLocalData cannot be used in this browser";
		}
		if (!document.readyState) {
			//try to do the onload (mozilla goes here)
			dataFrame.onload = __loadLocalIFrameXML;
		}
		else {
			//else send it to the readystatechecker (everybody elses goes here)
			window.setTimeout("__readyStateChecker()", 250);
		}
	}
	catch (badFailure) {
		_xmlIOLoadLocalDataLastLoadStatus = badFailure;
	}

	_xmlIOLoadLocalDataLastLoadStatus = "Ending xmlIOLoadLocalData";


} // end function xmlIOLoadLocalData


function __readyStateChecker() {
	/********************************************************************************
	Function: __readyStateChecker

	Author: djoham@yahoo.com

	Description:
			checks the readState of the IFrame document. Tries again and again
			for 10 seconds before it gives up and sends control to the function
			that returns the XML back to the callback function

	*********************************************************************************/

	var dataFrame;

	_xmlIOLoadLocalDataLastLoadStatus = "Starting __readyStateChecker";

	try {
		//(konq, Opera and Moz go here)
		dataFrame = document.getElementById(_xmlIOLoadlocalDataIFrameID).contentDocument.readyState;
	}
	catch (imIE) {
		try {
			//(IE win or mac)
			dataFrame = document.getElementById(_xmlIOLoadlocalDataIFrameID).contentWindow.document.readyState;
		}
		catch (imIEMac) {
			try {
				//mac IE goes here - mac ie readystate doesn't seem to work,
				//so I just check for an empty innerHTML.
				//try for 10 seconds
				if (_xmlIOLoadLocalDataRetryCount < 41) {
					if (__trim(window.frames[_xmlIOLoadlocalDataIFrameID].document.body.innerHTML, true, true) == "") {
						_xmlIOLoadLocalDataRetryCount++;
						_xmlIOLoadLocalDataLastLoadStatus = "Calling __readyStateChecker again";
						window.setTimeout("__readyStateChecker()", 250);
						return;
					}
					else {
						//we have data - assume we have it all and call the IFrame XML getter
						_xmlIOLoadLocalDataLastLoadStatus = "Calling __loadLocalIFrameXML";
						__loadLocalIFrameXML();
						return;
					}
				}
				else {
					//maybe the document is supposed to be empty?
					_xmlIOLoadLocalDataLastLoadStatus = "__readyStateChecker TimeOut - calling __loadLocalIFrameXML anyway";
					__loadLocalIFrameXML();
				}
				return;
			}
			catch (badFailure) {
				//punt
				_xmlIOLoadLocalDataLastLoadStatus = "__readStateChecker unrecoverable error: " + badFailure;
				return;
			}
		}
	}
	if (dataFrame.toLowerCase() != "complete" ) {
		//try for 10 seconds
		if (_xmlIOLoadLocalDataRetryCount > 40 ) {
			//giving up and calling the local IFrame XML getter
			_xmlIOLoadLocalDataLastLoadStatus = "__readyStateChecker TimeOut - calling __loadLocalIFrameXML anyway";
			__loadLocalIFrameXML();
		}
		else {
			//try again
			_xmlIOLoadLocalDataRetryCount++;
			_xmlIOLoadLocalDataLastLoadStatus = "Calling __readyStateChecker again";
			window.setTimeout("__readyStateChecker()", 250);
		}
	}
	else {
		_xmlIOLoadLocalDataLastLoadStatus = "Calling __loadLocalIFrameXML";
		__loadLocalIFrameXML();
	}

} // end function __readyStateChecker


function __loadLocalIFrameXML() {
	/********************************************************************************
	Function: __loadLocalIFrameXML

	Author: djoham@yahoo.com

	Description:
			Gets the XML from the IFrame created in xmlIOLoadLocalData,
			unescapes it and then sends it to the callback function

	*********************************************************************************/

	_xmlIOLoadLocalDataLastLoadStatus = "Starting __loadLocalIFrameXML";

	var xmlString = "";

	try {
		var dataFrame = document.getElementById(_xmlIOLoadlocalDataIFrameID);
		try {
			//(Konqueror, Opera and Mozilla get this)
			xmlString = dataFrame.contentDocument.body.innerHTML;
		}
		catch (imIE) {
			try {
				xmlString = dataFrame.contentWindow.document.body.innerHTML;
			}
			catch (imIEMac) {
				xmlString = window.frames[_xmlIOLoadlocalDataIFrameID].document.body.innerHTML;
			}
		}
		try {
			document.body.removeChild(dataFrame);
		}
		catch (badFailure) {
			_xmlIOLoadLocalDataLastLoadStatus = "__loadLocalIFrameXML unrecoverable error(1): " + badFailure;
		}
	}
	catch (badFailure2) {
		_xmlIOLoadLocalDataLastLoadStatus = "__loadLocalIFrameXML unrecoverable error(2): " + badFailure2;
	}

	try {
		//The xmlString is escaped. use the XML for <SCRIPT>'s unescape function.
		//Put the catch in here to make sure the programmer has included it
		xmlString = xmlUnescapeHTMLToXML(xmlString)
	}
	catch (e) {
		alert(e);
		_xmlIOLoadLocalDataLastLoadStatus = "__loadLocalIFrameXML unrecoverable error: The function xmlUnescapeHTMLToXML was not found. Did you include xmlEscape.js (from the jsTools directory) in your HTML file?";
	}

	try {

		eval(_xmlIOLoadLocalDataCallbackFunction + "(xmlString)");
		_xmlIOLoadLocalDataLastLoadStatus = "__loadLocalIFrameXML successfully called callback function";
	}
	catch (e) {
		_xmlIOLoadLocalDataLastLoadStatus = "__loadLocalIFrameXML unrecoverable error: Is your callback function correct?";
	}


}

function xmlIOLoadLocalGetLastLoadStatus() {

	return _xmlIOLoadLocalDataLastLoadStatus;

} //end function xmlIOLoadLocalGetLastLoadStatus

/************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************
										Helper Functions
*************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************/

function __trim(trimString, leftTrim, rightTrim) {
	/*******************************************************************************************************************
	function: _isEmpty

	Author: may106@psu.edu

	Description:
		helper function to trip a string (trimString) of leading (leftTrim)
		and trailing (rightTrim) whitespace

		Copied from xmldom.js

	*********************************************************************************************************************/
	var whitespace = "\n\r\t ";

	if (__isEmpty(trimString)) {
		return "";
	}

	// the general focus here is on minimal method calls - hence only one
	// substring is done to complete the trim.

	if (leftTrim == null) {
		leftTrim = true;
	}

	if (rightTrim == null) {
		rightTrim = true;
	}

	var left=0;
	var right=0;
	var i=0;
	var k=0;

	// modified to properly handle strings that are all whitespace
	if (leftTrim == true) {
		while ((i<trimString.length) && (whitespace.indexOf(trimString.charAt(i++))!=-1)) {
			left++;
		}
	}
	if (rightTrim == true) {
		k=trimString.length-1;
		while((k>=left) && (whitespace.indexOf(trimString.charAt(k--))!=-1)) {
			right++;
		}
	}
	return trimString.substring(left, trimString.length - right);
} // end function _trim



function __isEmpty(str) {
	/*******************************************************************************************************************
	function: __isEmpty

	Author: mike@idle.org

	Description:
		convenience function to identify an empty string
		copied from xmldom.js
	*********************************************************************************************************************/
	return (str==null) || (str.length==0);

} // end function __isEmpty

// =========================================================================
//
// xmlxpath.js - a partially W3C compliant XPath parser for XML for <SCRIPT>
//
// version 3.1
//
// =========================================================================
//
// Copyright (C) 2003 Jon van Noort <jon@webarcana.com.au> and David Joham <djoham@yahoo.com>
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.

// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
// Lesser General Public License for more details.

// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA	02111-1307	USA
//
// visit the XML for <SCRIPT> home page at xmljs.sourceforge.net
//
// Contributor - Jon van Noort <jon@webarcana.com.au>
//
// Contains code derived from works by Mark Bosley & Fred Baptiste
//	(see: http://www.topxml.com/people/bosley/strlib.asp)
//
// Contains text (used within comments to methods) from the
//	XML Path Language (XPath) Version 1.0 W3C Recommendation
//	Copyright � 16 November 1999 World Wide Web Consortium,
//	(Massachusetts Institute of Technology,
//	European Research Consortium for Informatics and Mathematics, Keio University).
//	All Rights Reserved.
//	(see: http://www.w3.org/TR/xpath)
//


// =========================================================================
// CONSTANT DECLARATIONS:
// =========================================================================
DOMNode.NODE_TYPE_TEST = 1;
DOMNode.NODE_NAME_TEST = 2;

DOMNode.ANCESTOR_AXIS			= 1;
DOMNode.ANCESTOR_OR_SELF_AXIS	= 2;
DOMNode.ATTRIBUTE_AXIS			 = 3;
DOMNode.CHILD_AXIS				 = 4;
DOMNode.DESCENDANT_AXIS			= 5;
DOMNode.DESCENDANT_OR_SELF_AXIS	= 6;
DOMNode.FOLLOWING_AXIS			 = 7;
DOMNode.FOLLOWING_SIBLING_AXIS	 = 8;
DOMNode.NAMESPACE_AXIS			 = 9;
DOMNode.PARENT_AXIS				= 10;
DOMNode.PRECEDING_AXIS			 = 11;
DOMNode.PRECEDING_SIBLING_AXIS	 = 12;
DOMNode.SELF_AXIS				= 13;

DOMNode.ROOT_AXIS				= 14;	// the self axis of the root node



// =========================================================================
//	XPATHNode Helpers 
// =========================================================================

// =========================================================================
// @method
// DOMNode.getStringValue - Return the concatenation of all of the DescandantOrSelf Text nodes
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : string 
// 
// ========================================================================= 
DOMNode.prototype.getStringValue = function() {
	var thisBranch = this._getDescendantOrSelfAxis();
	var textNodes = thisBranch.getTypedItems("text");
	var stringValue = "";

	if (textNodes.length > 0) {
	stringValue += textNodes.item(0).nodeValue;

	for (var i=1; i < textNodes.length ; i++) {
		stringValue += " "+ textNodes.item(i).nodeValue;	// separate TextNodes with spaces
	}
	}

	return stringValue;
};

DOMNode.prototype._filterByAttributeExistance = function(expr, containerNodeSet) {

	try {
		//handle [@id] condition
		if (expr.indexOf("*") < 0) {
			var attributeName = expr.substr(1, expr.length);
			var attribute = this.getAttributes().getNamedItem(attributeName);

			if (attribute != null) {
				return true;
			}
			else {
				return false;
			}
		}

		//handle [@*] situation
		else {
			if (this.getAttributes().getLength() > 0 ) {
				return true;
			}
			else {
				return false;
			}
		}
	}
	catch (e) {
		return false;
	}
}

DOMNode.prototype._filterByAttributeValue = function(expr, containerNodeSet) {

	//handle situation such as [@id=1], [@id='1'] and/or [@id="1"]
	try {
		//get some locations we'll need later
		var nameStart = expr.indexOf("@") + 1;
		var equalsStart = expr.indexOf("=");

		//get the attribute name we're looking for
		var attributeName = expr.substr(nameStart, expr.indexOf("=", nameStart) - 1);

		//get the value we're looking for
		var valueTesting = expr.substr(equalsStart + 1, expr.length);

		//handle situations like [@id="1"] and [@id='1']
		if (valueTesting.charAt(0) == "\"" || valueTesting.charAt(0) == "'") {
			valueTesting = valueTesting.substr(1, valueTesting.length);
		}

		if (valueTesting.charAt(valueTesting.length - 1) == "\"" || valueTesting.charAt(valueTesting.length - 1) == "'") {
			valueTesting = valueTesting.substr(0, valueTesting.length -1);
		}

		//now I have the attribute name. Try to get it
		var attribute = this.getAttributes().getNamedItem(attributeName);

		//test for equality
		if (attribute.getValue() == valueTesting) {
			return true;
		}
		else {
			return false;
		}
	}
	catch (e) {
		return false
	}

}

DOMNode.prototype._filterByAttribute = function(expr, containerNodeSet) {

	//handle searches for the existance of any attributes
	if (expr == "@*") {
		return this._filterByAttributeExistance(expr, containerNodeSet);
	}

	//test to see if they just want elements with a specific attribute [@id]
	if (expr.indexOf("=") < 0) {
		return this._filterByAttributeExistance(expr, containerNodeSet);
	}

	//if we got here, we're looking for an attribute value
	return this._filterByAttributeValue(expr, containerNodeSet);

}

DOMNode.prototype._filterByNot = function(expr, containerNodeSet) {

	//handle something like [not(<expression>)]
	//first, remove the "not part
	expr = expr.substr(4, expr.length);

	//find the end of the not
	var endNotLocation = this._findExpressionEnd(expr, "(", ")");

	//get the full expression
	expr = expr.substr(0, endNotLocation);

	//now return the not of the filter value
	return !this._filter(expr, containerNodeSet);
}

DOMNode.prototype._findExpressionEnd = function(expression, startCharacter, endCharacter) {

	//make sure to handle the case where we have nested expressions
	var startCharacterNum = 0;
	var endExpressionLocation = 0;
	var intCount = expression.length;


	for (intLoop = 0; intLoop < intCount; intLoop++) {
		var character = expression.charAt(intLoop);
		switch(character) {
			case startCharacter:
				startCharacterNum++;
				break;

			case endCharacter:
				if (startCharacterNum == 0) {
					endExpressionLocation = intLoop;
				}
				else {
					startCharacterNum--;
				}
				break;
		}

		if (endExpressionLocation != 0) {
			break;
		}
	}

	return endExpressionLocation;

}

DOMNode.prototype._filterByLocation = function(expr, containerNodeSet) {

	//handle situation like [1]
	var item = 0 + expr - 1; //xpath is 1 based, w3cdom is 0 based
	//compare ourselves to the list
	if (this == containerNodeSet.item(item)) {
		return true;
	}
	else {
		return false;
	}

}

DOMNode.prototype._filterByLast = function(expr, containerNodeSet) {

	//handle situation likd [last()]
	if (this == containerNodeSet.item(containerNodeSet.length -1)) {
		return true;
	}
	else {
		return false;
	}
}

DOMNode.prototype._filterByCount = function(expr, containerNodeSet) {

	//get the count we're looking for
	var countStart = expr.indexOf("=") + 1;
	var countStr = expr.substr(countStart, expr.length);

	var countInt = parseInt(countStr);

	//separate out the "count(" part
	expr = expr.substr(6, expr.length);

	//get the expression
	expr = expr.substr(0, this._findExpressionEnd(expr, "(", ")"));
	//if expr is "*", the logic here doesn't work. Just return false
	//the reason it doesn't work is that while we may find a node under us
	//that has the proper number of children, we can only return true
	//or false for *this* node. So, if we find something that matches,
	//we'll be returning false for the wrong node.
	//TODO: fix this somehow
	if (expr == "*") {
		return false;
	}

	//otherwise, give it a go...
	var tmpNodeSet = this.selectNodeSet(expr);
	var tmpNodeSetLength = tmpNodeSet.length;

	if (tmpNodeSetLength == countInt) {
		return true;
	}
	else {
		return false;
	}

}

DOMNode.prototype._filterByName = function(expr, containerNodeSet) {

	//get the name we're looking for
	//start at the first equal sign
	var equalLocation = expr.indexOf("=");

	//get the next character. This should be either a single or double quote
	var quoteChar = expr.charAt(equalLocation + 1);

	//our name will be the text after the quoteChar until the next quoteChar is found
	var name = "";
	for (intLoop = equalLocation + 2; intLoop < expr.length; intLoop++) {
		if (expr.charAt(intLoop) == quoteChar) {
			break;
		}
		else {
			name += expr.charAt(intLoop);
		}
	}

	if (this.getNodeName() == name) {
		return true;
	}
	else {
		return false;
	}

}

DOMNode.prototype._filterByPosition = function(expr, containerNodeSet) {

	//find the location I'm looking for
	var equalsLocation = expr.indexOf("=");
	var tmpPos = expr.substr(equalsLocation + 1, expr.length);

	//I need to check for position()=last()
	if (tmpPos.indexOf("last()") == 0) {
		//see if we're the last dude in the list
		if (this == containerNodeSet.item(containerNodeSet.length -1)) {
			return true;
		}
		else {
			return false;
		}
	}

	//OK, it wasn't last so that means there's a numeric number here. Find it
	var intCount = tmpPos.length;
	var positionStr = "";
	for (intLoop = 0; intLoop < intCount; intLoop++) {
		if (isNaN(positionStr + tmpPos.charAt(intLoop)) == false) {
			positionStr+=tmpPos.charAt(intLoop);
		}
		else {
			break;
		}
	}

	//OK, we have the position, get the int value and do the comparison
	var positionInt = parseInt(positionStr) - 1; //minus 1 because xpath is 1 based but w3cdom is 0 based
	if (this == containerNodeSet.item(positionInt) ) {
		return true;
	}
	else {
		return false;
	}

}

// =========================================================================
// @method
// DOMNode._filter - Returns true if the expression evaluates to true
//						and otherwise returns false
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param
// expr : string - The XPath Predicate Expression
// containerNodeSet : XPATHNodeSet - the NodeSet containing this node
//
// @return
// : boolean
//
// =========================================================================
DOMNode.prototype._filter = function(expr, containerNodeSet) {

	expr = trim(expr, true, true);

	//handle not()
	if (expr.indexOf("not(") == 0) {
	return this._filterByNot(expr, containerNodeSet);
	}

	//handle count()
	if (expr.indexOf("count(") == 0) {
	return this._filterByCount(expr, containerNodeSet);
	}

	//handle name()
	if (expr.indexOf("name(") == 0) {
	return this._filterByName(expr, containerNodeSet);
	}

	//handle [position() = 1]
	if (expr.indexOf("position(") == 0) {
	return this._filterByPosition(expr, containerNodeSet);
	}


	//handle attribute searches
	if (expr.indexOf("@") > -1 ) {
	return this._filterByAttribute(expr, containerNodeSet);
	}


	//handle the case of something like [1]
	if (isNaN(expr) == false) {
	return this._filterByLocation(expr, containerNodeSet);
	}

	//handle [last()]
	if (expr == "last()") {
	return this._filterByLast(expr, containerNodeSet);
	}


}


// =========================================================================
// @method
// DOMNode._getAxis - Return a NodeSet containing all Nodes in the specified Axis
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param
// axisConst : int - the id of the Axis Type
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getAxis = function(axisConst) {
	if (axisConst == DOMNode.ANCESTOR_AXIS)				return this._getAncestorAxis();
	else if (axisConst == DOMNode.ANCESTOR_OR_SELF_AXIS)	 return this._getAncestorOrSelfAxis();
	else if (axisConst == DOMNode.ATTRIBUTE_AXIS)			return this._getAttributeAxis();
	else if (axisConst == DOMNode.CHILD_AXIS)				return this._getChildAxis();
	else if (axisConst == DOMNode.DESCENDANT_AXIS)		 return this._getDescendantAxis();
	else if (axisConst == DOMNode.DESCENDANT_OR_SELF_AXIS) return this._getDescendantOrSelfAxis();
	else if (axisConst == DOMNode.FOLLOWING_AXIS)			return this._getFollowingAxis();
	else if (axisConst == DOMNode.FOLLOWING_SIBLING_AXIS)	return this._getFollowingSiblingAxis();
	else if (axisConst == DOMNode.NAMESPACE_AXIS)			return this._getNamespaceAxis();
	else if (axisConst == DOMNode.PARENT_AXIS)			 return this._getParentAxis();
	else if (axisConst == DOMNode.PRECEDING_AXIS)			return this._getPrecedingAxis();
	else if (axisConst == DOMNode.PRECEDING_SIBLING_AXIS)	return this._getPrecedingSiblingAxis();
	else if (axisConst == DOMNode.SELF_AXIS)				 return this._getSelfAxis();
	else if (axisConst == DOMNode.ROOT_AXIS)				 return this._getRootAxis();


	else {
	alert('Error in DOMNode._getAxis: Attempted to get unknown axis type '+ axisConst);
	return null;
	}
};


// =========================================================================
// The ancestor, descendant, following, preceding and self axes partition a document
// (ignoring attribute and namespace nodes): they do not overlap and together they contain
// all the nodes in the document.
// =========================================================================

// =========================================================================
// @method
// DOMNode._getAncestorAxis - Return a NodeSet containing all Nodes in ancestor axis.
//	 The ancestor axis contains the ancestors of the context node; the ancestors of the
//	 context node consist of the parent of context node and the parent's parent and so on;
//	 thus, the ancestor axis will always include the root node, unless the context node is
//	 the root node.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getAncestorAxis = function() {
	var parentNode = this.parentNode;

	if (parentNode.nodeType != DOMNode.DOCUMENT_NODE ) {
	return this.parentNode._getAncestorOrSelfAxis();
	}
	else {
	return new XPATHNodeSet(this.ownerDocument, this.parentNode, null);	// return empty NodeSet
	}
};


// =========================================================================
// @method
// DOMNode._getAncestorOrSelfAxis - Return a NodeSet containing all Nodes in ancestor or self axes.
//	 The ancestor-or-self axis contains the context node and the ancestors of the
//	 context node; thus, the ancestor axis will always include the root node.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getAncestorOrSelfAxis = function() {
	return this._getSelfAxis().union(this._getAncestorAxis());
};


// =========================================================================
// @method
// DOMNode._getAttributeAxis - Return a NodeSet containing all Nodes in the attribute axis.
//	 The attribute axis contains the attributes of the context node; the axis will
//	 be empty unless the context node is an element.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getAttributeAxis = function() {
	return new XPATHNodeSet(this.ownerDocument, this.parentNode, this.attributes);
};


// =========================================================================
// @method
// DOMNode._getChildAxis - Return a NodeSet containing all Nodes in the child axis.
//	 The child axis contains the children of the context node.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getChildAxis = function() {
	return new XPATHNodeSet(this.ownerDocument, this.parentNode, this.childNodes);
};


// =========================================================================
// @method
// DOMNode._getDescendantAxis - Return a NodeSet containing all Nodes in the descendant axis.
//	 The descendant axis contains the descendants of the context node; a descendant is
//	 a child or a child of a child and so on; thus the descendant axis never contains
//	 attribute or namespace nodes.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getDescendantAxis = function() {
	var descendantNodeSet = new XPATHNodeSet(this.ownerDocument, this.parentNode, null);

	for (var i=0; i < this.childNodes.length; i++) {
	descendantNodeSet.union(this.childNodes.item(i)._getDescendantOrSelfAxis());
	}

	return descendantNodeSet;
};

// =========================================================================
// @method
// DOMNode._getReversedDescendantAxis - Return a NodeSet containing all Nodes in the descendant axis,
//	 in Reverse Document Order .
//	 The descendant axis contains the descendants of the context node; a descendant is
//	 a child or a child of a child and so on; thus the descendant axis never contains
//	 attribute or namespace nodes.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getReversedDescendantAxis = function() {
	var descendantNodeSet = new XPATHNodeSet(this.ownerDocument, this.parentNode, null);

	for (var i=this.childNodes.length -1; i >= 0; i--) {
	descendantNodeSet.union(this.childNodes.item(i)._getReversedDescendantOrSelfAxis());
	}

	return descendantNodeSet;
};


// =========================================================================
// @method
// DOMNode._getDescendantOrSelfAxis - Return a NodeSet containing all Nodes in the descendant or self axes.
//	 The descendant-or-self axis contains the context node and the descendants of the context node.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getDescendantOrSelfAxis = function() {
	return this._getSelfAxis().union(this._getDescendantAxis());
};


// =========================================================================
// @method
// DOMNode._getReversedDescendantOrSelfAxis - Return a NodeSet containing all Nodes in the descendant or self axes,
//	 in Reverse Document Order.
//	 The descendant-or-self axis contains the context node and the descendants of the context node.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getReversedDescendantOrSelfAxis = function() {
	return this._getSelfAxis().union(this._getReversedDescendantAxis());
};


// =========================================================================
// @method
// DOMNode._getFollowingAxis - Return a NodeSet containing all Nodes in the following axes.
//	 The following axis contains all nodes in the same document as the context node that
//	 are after the context node in document order, excluding any descendants and excluding
//	 attribute nodes and namespace nodes.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getFollowingAxis = function() {
	var followingNodeSet = new XPATHNodeSet(this.ownerDocument, this.parentNode, null);

	if (this.nextSibling) {
	followingNodeSet._appendChild(this.nextSibling);
	followingNodeSet.union(this.nextSibling._getDescendantAxis());
	followingNodeSet.union(this.nextSibling._getFollowingAxis());
	}

	return followingNodeSet;
};


// =========================================================================
// @method
// DOMNode._getFollowingSiblingAxis - Return a NodeSet containing all sibling Nodes in the following axes.
//	 The following-sibling axis contains all the following siblings of the context node;
//	 if the context node is an attribute node or namespace node, the following-sibling axis is empty.
//	 ie, only the nodes that are sibling to the context node, not their descandants
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getFollowingSiblingAxis = function() {
	var followingSiblingNodeSet = new XPATHNodeSet(this.ownerDocument, this.parentNode, null);

	if (this.nextSibling) {
	followingSiblingNodeSet._appendChild(this.nextSibling);
	followingSiblingNodeSet.union(this.nextSibling._getFollowingSiblingAxis());
	}

	return followingSiblingNodeSet;
};


// =========================================================================
// @method
// DOMNode._getNamespaceAxis - Return a NodeSet containing nodes in the Namespace axis.
//	 the namespace axis contains the namespace nodes of the context node; the axis will
//	 be empty unless the context node is an element.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
// DOMNode.prototype._getNamespaceAxis = function() { };


// =========================================================================
// @method
// DOMNode._getParentAxis - Return a NodeSet containing the parent node of the context node.
//	 The parent axis contains the parent of the context node, if there is one.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getParentAxis = function() {
	var parentNodeSet = new XPATHNodeSet(this.ownerDocument, this.parentNode, null);
	var parentNode = this.parentNode;

	if (parentNode) {
	parentNodeSet._appendChild(parentNode);
	}

	return parentNodeSet;
};


// =========================================================================
// @method
// DOMNode._getPrecedingAxis - Return a NodeSet containing all Nodes in the preceding axis.
//	 The preceding axis contains all nodes in the same document as the context node that
//	 are before the context node in document order, excluding any ancestors and excluding
//	 attribute nodes and namespace nodes.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getPrecedingAxis = function() {
	var precedingNodeSet = new XPATHNodeSet(this.ownerDocument, this.parentNode, null);

	if (this.previousSibling) {
	precedingNodeSet.union(this.previousSibling._getReversedDescendantAxis());
	precedingNodeSet._appendChild(this.previousSibling);
	precedingNodeSet.union(this.previousSibling._getPrecedingAxis());
	}

	return precedingNodeSet;
};


// =========================================================================
// @method
// DOMNode._getPrecedingSiblingAxis - Return a NodeSet containing all sibling Nodes in the preceding axis.
//	 The preceding axis contains all nodes in the same document as the context node that
//	 are before the context node in document order, excluding any ancestors and excluding
//	 attribute nodes and namespace nodes.
//	 ie, only the nodes that are sibling to the context node, not their descandants
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getPrecedingSiblingAxis = function() {
	var precedingSiblingNodeSet = new XPATHNodeSet(this.ownerDocument, this.parentNode, null);

	if (this.previousSibling) {
	precedingSiblingNodeSet._appendChild(this.previousSibling);
	precedingSiblingNodeSet.union(this.previousSibling._getPrecedingSiblingAxis());
	}

	return precedingSiblingNodeSet;
};


// =========================================================================
// @method
// DOMNode._getSelfAxis - Return a NodeSet containing the context node.
//	 The self axis contains just the context node itself.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getSelfAxis = function() {
	var selfNodeSet = new XPATHNodeSet(this.ownerDocument, this.parentNode, null);
	selfNodeSet._appendChild(this);

	return selfNodeSet;
};


// =========================================================================
// @method
// DOMNode._getRootAxis - Return a NodeSet containing the root node.
//	 The root axis contains just the root node itself.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype._getRootAxis = function() {
	var rootNodeSet = new XPATHNodeSet(this.ownerDocument, this.parentNode, null);
	rootNodeSet._appendChild(this.documentElement);

	return rootNodeSet;
};


// =========================================================================
// @method
// DOMNode.selectNodeSet - Returns NodeSet containing nodes matching XPath expression
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param
// locationPath : string - the XPath expression
//
// @return
// : XPATHNodeSet
//
// =========================================================================
DOMNode.prototype.selectNodeSet = function (locationPath) {
	// transform '//' root-recursive reference before split
	locationPath = locationPath.replace(/^\//g, 'root::');
	var result;
	try {
	result = this.selectNodeSet_recursive(locationPath);
	return result;
	}
	catch (e) {
	return null;
	}

}

// =========================================================================
// @method
// DOMNode.selectNodeSet_recursive - Returns NodeSet containing nodes matching XPath expression
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param
// locationPath : string - the XPath expression
// 
// @return 
// : XPATHNodeSet
// 
// ========================================================================= 
DOMNode.prototype.selectNodeSet_recursive = function (locationPath) {

	// split LocationPath into Steps on '/'
	var locationSteps = locationPath.split('/');
	var candidateNodeSet;
	var resultNodeSet = new XPATHNodeSet(this.ownerDocument, this.parentNode);

	// get first step

	if (locationSteps.length > 0) {

	/* original code - didn't work in IE 5.x for the mac
	var stepStr = locationSteps.shift();
	*/

	/* new code. Slower, but more compatible. */
	var stepStr = locationSteps[0];
	locationSteps = __removeFirstArrayElement(locationSteps);
	/*end new code*/

	var stepObj = this._parseStep(stepStr);

	// parse Step (Axis, NodeTest, PredicateList)
	var axisStr			= stepObj.axis;
	var nodeTestStr		= stepObj.nodeTest;
	var predicateListStr = stepObj.predicateList;

	// get AxisType
	var axisType = this._parseAxis(axisStr);

	// parse NodeTest (type, value)
	var nodeTestObj = this._parseNodeTest(nodeTestStr);
	var nodeTestType	= nodeTestObj.type;
	var nodeTestValue = nodeTestObj.value;

	// Build NodeSet with Nodes from AxisSpecifier
	candidateNodeSet = this._getAxis(axisType);

	// Filter NodeSet by NodeTest
	if (nodeTestType == DOMNode.NODE_TYPE_TEST) {
		candidateNodeSet = candidateNodeSet.getTypedItems(nodeTestValue);
	}	
	else if (nodeTestType == DOMNode.NODE_NAME_TEST) {
		candidateNodeSet = candidateNodeSet.getNamedItems(nodeTestValue);
	}

	// parse Predicates
	var predicateList = this._parsePredicates(predicateListStr);

	// apply each predicate in turn
	for (predicate in predicateList) {
		// filter NodeSet by applying Predicate
		candidateNodeSet = candidateNodeSet.filter(predicateList[predicate]);
	}

	// recursively apply remaining steps in Location Path
	if (locationSteps.length > 0) {
		var remainingLocationPath = locationSteps.join('/');
		candidateNodeSet = candidateNodeSet.selectNodeSet_recursive(remainingLocationPath);
	}
	}	

	return candidateNodeSet;
};


// =========================================================================
// @method
// DOMNode._nodeTypeIs - Returns true if the node is of specified type 
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param 
// node : DOMNode - the Node to be tested
// type : int - the id of the required type
// 
// @return 
// : boolean 
// 
// ========================================================================= 
DOMNode.prototype._nodeTypeIs = function(node, type) {
	return (node.nodeType == type);
};


// =========================================================================
// @method
// DOMNode._nodeNameIs - Returns true if the node has the specified name 
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param 
// node : DOMNode - the Node to be tested
// name : string - the name of the required node(s)
// 
// @return 
// : boolean 
// 
// ========================================================================= 
DOMNode.prototype._nodeNameIs = function(node, name) {
	return (node.nodeName == name);
};

// =========================================================================
// @method
// DOMNode._parseStep - Parse the LocationStep
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param 
// step : string - the LocationStep expression, ie, the string between containing '/'s
// 
// @return 
// (
//	 axis : string - the axis
//	 nodeTest : string - the name or type of node
//	 predicateList : string - zero or more Predicate Expressions, ie, the expressions contained within '[..]'
// )
// 
// ========================================================================= 
DOMNode.prototype._parseStep = function(step) {
	var resultStep = new Object();
	resultStep.axis = "";
	var nodeTestStartInd = 0;		// start of NodeTest string defaults to starting at begining of string

	// test existance of AxisSpecifier
	var axisEndInd = step.indexOf('::');
	if (axisEndInd > -1) {
	resultStep.axis = step.substring(0, axisEndInd);								// extract axis
	nodeTestStartInd = axisEndInd +2;
	}

	// test existance of Predicates
	resultStep.predicateList = "";
	var predicateStartInd = step.indexOf('[');
	if (predicateStartInd > -1) {
	resultStep.predicateList = step.substring(predicateStartInd);			 // extract predicateList
	resultStep.nodeTest = step.substring(nodeTestStartInd, predicateStartInd);	// extract nodeTest
	}
	else {
	resultStep.nodeTest = step.substring(nodeTestStartInd);						 // extract nodeTest
	}

	if (resultStep.nodeTest.indexOf('@') == 0) {									// '@' is shorthand for
	resultStep.axis = 'attribute';												// axis is atttribute
	resultStep.nodeTest = resultStep.nodeTest.substring(1);						 // remove '@' from string
	}

	if (resultStep.nodeTest.length == 0) {											// '//' is shorthand for
	resultStep.axis = 'descendant-or-self';										 // axis is descendant-or-self
	}

	if (resultStep.nodeTest == '..') {												// '..' is shorthand for
	resultStep.axis = 'parent';													 // axis is parent
	resultStep.nodeTest = 'node()';
	}

	if (resultStep.nodeTest == '.') {												 // '.' is shorthand for
	resultStep.axis = 'self';													 // axis is self
	resultStep.nodeTest = 'node()';
	}

	return resultStep;
};

// =========================================================================
// @method
// DOMNode._parseAxis - Parse the Axis, return axis type id
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param 
// axisStr : string - the axis string
// 
// @return 
// : int
// ========================================================================= 
DOMNode.prototype._parseAxis = function(axisStr) {

	var returnAxisType = DOMNode.CHILD_AXIS;	// axis defaults to "child"
	// convert axis & alias strings to axisType consts
	if (axisStr == 'ancestor')				returnAxisType = DOMNode.ANCESTOR_AXIS;
	else if (axisStr == 'ancestor-or-self')	 returnAxisType = DOMNode.ANCESTOR_OR_SELF_AXIS;
	else if (axisStr == 'attribute')			returnAxisType = DOMNode.ATTRIBUTE_AXIS;
	else if (axisStr == 'child')				returnAxisType = DOMNode.CHILD_AXIS;
	else if (axisStr == 'descendant')		 returnAxisType = DOMNode.DESCENDANT_AXIS;
	else if (axisStr == 'descendant-or-self') returnAxisType = DOMNode.DESCENDANT_OR_SELF_AXIS;
	else if (axisStr == 'following')			returnAxisType = DOMNode.FOLLOWING_AXIS;
	else if (axisStr == 'following-sibling')	returnAxisType = DOMNode.FOLLOWING_SIBLING_AXIS;
	else if (axisStr == 'namespace')			returnAxisType = DOMNode.NAMESPACE_AXIS;
	else if (axisStr == 'parent')			 returnAxisType = DOMNode.PARENT_AXIS;
	else if (axisStr == 'preceding')			returnAxisType = DOMNode.PRECEDING_AXIS;
	else if (axisStr == 'preceding-sibling')	returnAxisType = DOMNode.PRECEDING_SIBLING_AXIS;
	else if (axisStr == 'self')				 returnAxisType = DOMNode.SELF_AXIS
	else if (axisStr == 'root')				 returnAxisType = DOMNode.ROOT_AXIS


	return returnAxisType;
}


// =========================================================================
// @method
// DOMNode._parseNodeTest - Parse the NodeTest, return axis type id
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param 
// nodeTestStr : string - the node test string
// 
// @return
// (
//	 type : int - the nodeTest type id
//	 value : string - the string of the nodeName or nodeType (depending on type)
// )
// ========================================================================= 
DOMNode.prototype._parseNodeTest = function(nodeTestStr) {
	var returnNodeTestObj = new Object();

	if (nodeTestStr.length == 0) {
	returnNodeTestObj.type = DOMNode.NODE_TYPE_TEST
	returnNodeTestObj.value = 'node';
	}
	else {
	var funInd = nodeTestStr.indexOf('(');
	if (funInd > -1) {
		returnNodeTestObj.type = DOMNode.NODE_TYPE_TEST
		returnNodeTestObj.value = nodeTestStr.substring(0, funInd);
	}
	else {
		returnNodeTestObj.type = DOMNode.NODE_NAME_TEST
		returnNodeTestObj.value = nodeTestStr;
	}
	}

	return returnNodeTestObj;
};


// =========================================================================
// @method
// DOMNode._parsePredicates - Parse the PredicateList, return array of Predicate Expression strings
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param 
// predicateListStr : string - the string containing list of (stacked) predicates
// 
// @return 
// [
//	 : string - the string of a Predicate Expression (sans enclosing '[]'s)
// ]
// ========================================================================= 
DOMNode.prototype._parsePredicates = function(predicateListStr) {
	var returnPredicateArray = new Array();

	if (predicateListStr.length > 0) {
	// remove top & tail square brackets to simplify the following split
	var firstOpenBracket = predicateListStr.indexOf('[');
	var lastCloseBracket = predicateListStr.lastIndexOf(']');

	predicateListStr = predicateListStr.substring(firstOpenBracket+1, lastCloseBracket);

	// split predicate list on ']['
	returnPredicateArray = predicateListStr.split('][');
	}

	return returnPredicateArray;
}


// =========================================================================
// @class
// XPATHNodeSet - Container of Nodes selected by XPath (sub)expression
//
// @extends
// DOMNodeList
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param 
// doc : string - the dom document that actually contains the Node data
// arr : [int]	- initial set of DOMNode _id(s)
// ========================================================================= 
XPATHNodeSet = function(ownerDocument, parentNode, nodeList) {
	this.DOMNodeList = DOMNodeList;
	this.DOMNodeList(ownerDocument, parentNode);
	 if (nodeList) {
	 for (var i=0; i < nodeList.length; i++) {
		this._appendChild(nodeList.item(i));
	 }
	 }

};
XPATHNodeSet.prototype = new DOMNodeList();


// =========================================================================
// @method
// XPATHNodeSet.selectNodeSet_recursive - Returns NodeSet containing nodes matching XPath expression
//	 for all Nodes within NodeSet.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param 
// xpath : string - the XPath expression
// 
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype.selectNodeSet_recursive = function(xpath) {
	var selectedNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	var candidateNode = this.item(i);
	selectedNodeSet.union(candidateNode.selectNodeSet_recursive(xpath));
	}

	return selectedNodeSet;
};

// =========================================================================
// @method
// XPATHNodeSet.getNamedItems - Returns NodeSet containing all nodes with specified name
//	 selected from the Nodes within the NodeSet.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param 
// xpath : string - the XPath expression
// 
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype.getNamedItems = function(nodeName) {
	var namedItemsNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	var candidateNode = this.item(i);
	if ((nodeName == '*') || (candidateNode.nodeName == nodeName)) {
		namedItemsNodeSet._appendChild(candidateNode);
	}
	}

	return namedItemsNodeSet;
};

// =========================================================================
// @method
// XPATHNodeSet.getTypedItems - Returns NodeSet containing all nodes with specified type
//	 selected from the Nodes within the NodeSet.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param 
// nodeType : int - the type id 
// 
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype.getTypedItems = function(nodeType) {
	var typedItemsNodeSet = new XPATHNodeSet(this.ownerDocument);
	var nodeTypeId;

		 if (nodeType.toLowerCase() == "node")	{ nodeTypeId = 0; }
	else if (nodeType.toLowerCase() == "text")	{ nodeTypeId = DOMNode.TEXT_NODE; }
	else if (nodeType.toLowerCase() == "comment") { nodeTypeId = DOMNode.COMMENT_NODE; }
	else if (nodeType.toLowerCase() == "processing-instruction") { nodeTypeId = DOMNode.PROCESSING_INSTRUCTION_NODE; }

	for (var i=0; i < this.length; i++) {
	var candidateNode = this.item(i);
	if ((nodeTypeId == 0) || (candidateNode.nodeType == nodeTypeId)) {
		typedItemsNodeSet._appendChild(candidateNode);
	}
	}

	return typedItemsNodeSet;
};




// =========================================================================
// @method
// XPATHNodeSet._getAxis - Returns a NodeSet containing the concatenation of all of the nodes 
//	 in the specified Axis for each node in the current NodeSet.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param 
// axisConst : int - the Axis type id
// 
// @return 
// : XPATHNodeSet
// 
// ========================================================================= 
XPATHNodeSet.prototype._getAxis = function(axisConst) { 
	if (axisConst == DOMNode.ANCESTOR_AXIS)				return this._getAncestorAxis();
	else if (axisConst == DOMNode.ANCESTOR_OR_SELF_AXIS)	 return this._getAncestorOrSelfAxis();
	else if (axisConst == DOMNode.ATTRIBUTE_AXIS)			return this._getAttributeAxis();
	else if (axisConst == DOMNode.CHILD_AXIS)				return this._getChildAxis();
	else if (axisConst == DOMNode.DESCENDANT_AXIS)		 return this._getDescendantAxis();
	else if (axisConst == DOMNode.DESCENDANT_OR_SELF_AXIS) return this._getDescendantOrSelfAxis();
	else if (axisConst == DOMNode.FOLLOWING_AXIS)			return this._getFollowingAxis();
	else if (axisConst == DOMNode.FOLLOWING_SIBLING_AXIS)	return this._getFollowingSiblingAxis();
	else if (axisConst == DOMNode.NAMESPACE_AXIS)			return this._getNamespaceAxis();
	else if (axisConst == DOMNode.PARENT_AXIS)			 return this._getParentAxis();
	else if (axisConst == DOMNode.PRECEDING_AXIS)			return this._getPrecedingAxis();
	else if (axisConst == DOMNode.PRECEDING_SIBLING_AXIS)	return this._getPrecedingSiblingAxis();
	else if (axisConst == DOMNode.SELF_AXIS)				 return this._getSelfAxis();
	else if (axisConst == DOMNode.ROOT_AXIS)				 return this._getRootAxis();

	else {
	alert('Error in XPATHNodeSet._getAxis: Attempted to get unknown axis type '+ axisConst);
	return null;
	}
};

	 
// =========================================================================
// @method
// XPATHNodeSet._getAncestorAxis - Return a NodeSet containing the concatenation of all of the nodes
//	 in the ancestor Axis for each node in the current NodeSet.
//	 The ancestor axis contains the ancestors of the context node; the ancestors of the
//	 context node consist of the parent of context node and the parent's parent and so on; 
//	 thus, the ancestor axis will always include the root node, unless the context node is
//	 the root node.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype._getAncestorAxis = function() {
	var ancestorAxisNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	ancestorAxisNodeSet.union(this.item(i)._getDescendantAxis());
	}
};


// =========================================================================
// @method
// DOMNode._getAncestorOrSelfAxis - Return a NodeSet	containing the concatenation of all of the nodes
//	 in the ancestor or self Axis for each node in the current NodeSet.
//	 The ancestor-or-self axis contains the context node and the ancestors of the
//	 context node; thus, the ancestor axis will always include the root node.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype._getAncestorOrSelfAxis = function() {
	var ancestorOrSelfAxisNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	ancestorOrSelfAxisNodeSet.union(this.item(i)._getAncestorOrSelfAxis());
	}
};


// =========================================================================
// @method
// DOMNode._getAttributeAxis - Return a NodeSet	containing the concatenation of all of the nodes 
//	 in the attribute Axis for each node in the current NodeSet.
//	 The attribute axis contains the attributes of the context node; the axis will 
//	 be empty unless the context node is an element.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype._getAttributeAxis = function() { 
	var attributeAxisNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	attributeAxisNodeSet.union(this.item(i)._getAttributeAxis());
	}
};


// =========================================================================
// @method
// DOMNode._getChildAxis - Return a NodeSet	containing the concatenation of all of the nodes 
//	 in the child Axis for each node in the current NodeSet.
//	 The child axis contains the children of the context node.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype._getChildAxis = function() { 
	var childNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	childNodeSet.union(this.item(i)._getChildAxis());
	}
};


// =========================================================================
// @method
// DOMNode._getDescendantAxis - Return a NodeSet	containing the concatenation of all of the nodes 
//	 in the descendant Axis for each node in the current NodeSet.
//	 The descendant axis contains the descendants of the context node; a descendant is 
//	 a child or a child of a child and so on; thus the descendant axis never contains 
//	 attribute or namespace nodes.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype._getDescendantAxis = function() { 
	var descendantNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	descendantNodeSet.union(this.item(i)._getDescendantAxis());
	}
};



// =========================================================================
// @method
// DOMNode._getReversedDescendantAxis - Return a NodeSet	containing the concatenation of all of the nodes 
//	 in the descendant Axis for each node in the current NodeSet in Reverse Document Order.
//	 The descendant axis contains the descendants of the context node; a descendant is 
//	 a child or a child of a child and so on; thus the descendant axis never contains 
//	 attribute or namespace nodes.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype._getReversedDescendantAxis = function() { 
	var descendantNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=this.length-1; i >= 0 ; i--) {
	descendantNodeSet.union(this.item(i)._getReversedDescendantAxis());
	}
};


// =========================================================================
// @method
// DOMNode._getDescendantOrSelfAxis - Return a NodeSet	containing the concatenation of all of the nodes 
//	 in the descendant or self	Axis for each node in the current NodeSet.
//	 The descendant-or-self axis contains the context node and the descendants of the context node.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype._getDescendantOrSelfAxis = function() { 
	var descendantOrSelfNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	descendantOrSelfNodeSet.union(this.item(i)._getDescendantOrSelfAxis());
	}
};


// =========================================================================
// @method
// DOMNode._getFollowingAxis - Return a NodeSet	containing the concatenation of all of the nodes 
//	 in the following Axis for each node in the current NodeSet.
//	 The following axis contains all nodes in the same document as the context node that 
//	 are after the context node in document order, excluding any descendants and excluding 
//	 attribute nodes and namespace nodes.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype._getFollowingAxis = function() { 
	var followingNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	followingNodeSet.union(this.item(i)._getFollowingAxis());
	}
};


// =========================================================================
// @method
// DOMNode._getFollowingSiblingAxis - Return a NodeSet	containing the concatenation of all of the nodes 
//	 in the following-sibling Axis for each node in the current NodeSet.
//	 The following-sibling axis contains all the following siblings of the context node; 
//	 if the context node is an attribute node or namespace node, the following-sibling axis is empty.
//	 ie, only the nodes that are sibling to the context node, not their descandants
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype._getFollowingSiblingAxis = function() { 
	var followingSibilingNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	followingSibilingNodeSet.union(this.item(i)._getFollowingSiblingAxis());
	}
};


// =========================================================================
// @method
// DOMNode._getNamespaceAxis - Return a NodeSet	containing the concatenation of all of the nodes 
//	 in the namespace Axis for each node in the current NodeSet.
//	 the namespace axis contains the namespace nodes of the context node; the axis will 
//	 be empty unless the context node is an element.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
// XPATHNodeSet.prototype._getNamespaceAxis = function() { };
//	NOT IMPLEMENTED



// =========================================================================
// @method
// DOMNode._getParentAxis - Return a NodeSet containing the concatenation of all of the nodes 
//	 in the parent Axis for each node in the current NodeSet.
//	 The parent axis contains the parent of the context node, if there is one.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype._getParentAxis = function() {
	var parentNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	parentNodeSet.union(this.item(i)._getParentAxis());
	}
};


// =========================================================================
// @method
// DOMNode._getPrecedingAxis - Return a NodeSet containing the concatenation of all of the nodes 
//	 in the preceding Axis for each node in the current NodeSet.
//	 The preceding axis contains all nodes in the same document as the context node that 
//	 are before the context node in document order, excluding any ancestors and excluding
//	 attribute nodes and namespace nodes.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype._getPrecedingAxis = function() { 
	var precedingNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	precedingNodeSet.union(this.item(i)._getPrecedingAxis());
	}
};


// =========================================================================
// @method
// DOMNode._getPrecedingSiblingAxis - Return a NodeSet	containing the concatenation of all of the nodes 
//	 in the preceding Axis for each node in the current NodeSet.
//	 The preceding axis contains all nodes in the same document as the context node that 
//	 are before the context node in document order, excluding any ancestors and excluding 
//	 attribute nodes and namespace nodes.
//	 ie, only the nodes that are sibling to the context node, not their descandants
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype._getPrecedingSiblingAxis = function() { 
	var precedingSiblingNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	precedingSiblingNodeSet.union(this.item(i)._getPrecedingSiblingAxis());
	}
};


// =========================================================================
// @method
// DOMNode._getSelfAxis - Return a NodeSet	containing the concatenation of all of the nodes 
//	 in the self Axis for each node in the current NodeSet.
//	 The self axis contains just the context node itself.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype._getSelfAxis = function() { 
	var selfNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	selfNodeSet.union(this.item(i)._getSelfAxis());
	}
};


// =========================================================================
// @method
// DOMNode.union - Return a NodeSet containing the concatenation of the current NodeSet
//	 and the supplied NodeSet
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param
// nodeSet : XPATHNodeSet - the NodeSet to be appended to this NodeSet
//
// @return
// : XPATHNodeSet
//
// ========================================================================= 
XPATHNodeSet.prototype.union = function(nodeSet) {
	for (var i=0; i < nodeSet.length; i++) {
	this._appendChild(nodeSet.item(i));
	}

	return this;
};


// =========================================================================
// @method
// DOMNode._getContainingNodeSet - Return this NodeSet.
//	 Note: this method is called from within the evaluation of a Predicate Expression,
//	 so that the Context Node can be advised of its containing NodeSet.
//	 This is required for the purposes of functions like poisition().
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @return 
// : XPATHNodeSet 
// 
// ========================================================================= 
XPATHNodeSet.prototype._getContainingNodeSet = function() { 
	return this;
};

XPATHNodeSet.prototype.getLength = function() {
	return this.length;
}

// =========================================================================
// @method
// XPATHNodeSet.filter - Returns a NodeSet containing the Nodes within the current NodeSet
//	 that satisfy the Predicate Expression.
//
// @author
// Jon van Noort (jon@webarcana.com.au)
//
// @param
// expressionStr : string - the XPathe Predicate Expression
//
// @return
// : XPATHNodeSet
//
// =========================================================================
XPATHNodeSet.prototype.filter = function(expressionStr) {
	var matchingNodeSet = new XPATHNodeSet(this.ownerDocument);

	for (var i=0; i < this.length; i++) {
	if (this.item(i)._filter(expressionStr, this)) {
		matchingNodeSet._appendChild(this.item(i));
	}
	}

	return matchingNodeSet;
};


function __removeFirstArrayElement(oldArray) {
	var newArray = new Array();

	try {
		for (intLoop = 1; intLoop < oldArray.length; intLoop++) {
			newArray[newArray.length] = oldArray[intLoop];
		}
	}
	catch (e) {
		//no op
	}
	return newArray;

}


