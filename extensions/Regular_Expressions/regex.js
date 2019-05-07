/**
	HTML5 Regex Script
	Version: 14.07.03.1
	Author: Reuben Shea
 **/

var keys=new Array();//Contains the matches from a search
var phrase="";
var reg=".*";

/**
	Name: regex_setinput
	Arguments:
	  argument0 - (string) New input to analyze
	Return: N/A

	Sets the string that will be compared against the
	regex expression.
 **/
function regex_setinput(argument0)
{
	phrase=argument0;
	return true;
}

/**
	Name: regex_setkey
	Arguments:
	  argument0 - (string) New regex string
	Returns: (bool) Whether regex string is formatted correctly

	Assigns a new regex string that will be used against 
	the set input.
 **/
function regex_setkey(argument0)
{
	try
	{
		//If this fails, we know the regex was incorrect.
		var key=new RegExp(argument0,"g");
		reg=argument0;
	}
	catch (e){
		//We "clear" the regex if it failed, then return failure.
		reg=".*";
		return false;
	}
	return true;
}

/**
	Name: regex_search
	Arguments: N/A
	Return: (bool) Whether there was a match

	Checks to see if there is a match between the regex and
	the phrase. It then stores the keys for later use.
	This will return true if any part of the phrase contains
	the regex expression.
 **/
function regex_search()
{
	//We use the "g" flag to mimic
	//the c++ counterparts.
	var key=new RegExp(reg,"g");
	keys=key.exec(phrase);
	
	if (keys==null)
		return false;
	else
		return true;
}

/**
	Name: regex_match
	Arguments: N/A
	Return: (bool) Whether there was an exact match

	Checks to see if there is an exact match between the regex and
	the phrase. It then stores the keys for later use.
	This will only return true if the phrase matches the regex
	expression exactly.
 **/
function regex_match()
{
	//We use the "g" flag to mimic
	//the c++ counterparts.
	var key=new RegExp("^"+reg+"$","g");
	keys=key.exec(phrase);
	
	if (keys==null)
		return false;
	else
		return true;
}

/**
	Name: regex_search_fast
	Arguments: N/A
	Returns: (bool) Whether there was a match

	This only tests if there is a match between the regex and
	the phrase. This does NOT record the keys and thus performs
	faster. This is useful if you only need to know if there was
	not a match, and not what matched.
 **/
function regex_search_fast()
{
	var key=new RegExp(reg,"g");
	if (keys.length>0)
		keys=new Array();
	return key.test(phrase);
}

/**
	Name: regex_match_fast
	Arguments: N/A
	Returns: (bool) Whether there was a match

	This only tests if there is an exact match between the regex and
	the phrase. This does NOT record the keys and thus performs
	faster. This is useful if you only need to know if there was
	not an exact match, and not what matched.
 **/
function regex_match_fast()
{
	var key=new RegExp("^"+reg+"$","g");
	if (keys.length>0)
		keys=new Array();
	return key.test(phrase);
}

/**
	Name: regex_matchcount
	Arguments: N/A
	Return: (int) The number of matches in the expression.

	Returns the number of keys stored from the last regex
	comparison.
 **/
function regex_matchcount()
{
	return keys.length;
}

/**
	Name: regex_getmatch
	Arguments:
	  argument0 - (int) The key number to grab the value from
	Return: (string) The contents of the specified key

	Grabs one of the matches from the previous regex search
	and returns it. An empty string is returned if an out
	of bounds location is specified.
 **/
function regex_getmatch(argument0)
{
	try
	{
		if (argument0<0 || argument0>keys.length)
			return "";
		if (keys[argument0]==null)
			return "";
		return keys[argument0];

	}
	catch (e)
	{
		return "";
	}
}

/**
	Name: regex_replace
	Arguments:
	  argument0 - (string)
	Returns: (string) Corrected response

	This will find all matches of the previously specified regex
	and phrase and replace them with the newly specified string.

	NOTE: This assumes a "search" and not a "match".
 **/
function regex_replace(argument0)
{
	var key=new RegExp(reg,"g");
	return phrase.replace(key,argument0);
}
