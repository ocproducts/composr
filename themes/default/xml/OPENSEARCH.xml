<?xml version="1.0" encoding="{$CHARSET*}"?>
<OpenSearchDescription xmlns="http://a9.com/-/spec/opensearch/1.1/">
	<ShortName>{$SITE_NAME*}{$_GET*,name}</ShortName>
	<Description>{DESCRIPTION*}</Description>
	<Url type="text/html" template="{$REPLACE`,searchTerms,\{searchTerms\},{$PAGE_LINK*,_SEARCH:search:results:content=searchTerms:days=-1{$_GET*,filter},0,1}}"/>
	<Url type="application/x-suggestions+json" template="{$FIND_SCRIPT*,opensearch}?type=suggest&amp;request=\{searchTerms\}&amp;filter={$REPLACE*,:,&,{$_GET,filter}}"/>
	<Image height="16" width="16" type="image/vnd.microsoft.icon">{$IMG*,favicon}</Image>
	<Query role="example" searchTerms="cat" />
	<Attribution>{$REPLACE`,{$COPYRIGHT},&copy;,(c)}</Attribution>
	<Language>{$LANG*}</Language>
	<OutputEncoding>{$CHARSET*}</OutputEncoding>
	<InputEncoding>{$CHARSET*}</InputEncoding>
</OpenSearchDescription>
