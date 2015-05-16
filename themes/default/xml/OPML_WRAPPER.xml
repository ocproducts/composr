<?xml-stylesheet href="{$FIND_SCRIPT*,backend}?type=xslt-opml{$KEEP*,0,1}" type="text/xsl" ?>
<!DOCTYPE opml [
<!ENTITY nbsp " " >
]>
<opml version="2.0">
	<head>
		<title>{$SITE_NAME*}</title>
		<dateCreated>{DATE*}</dateCreated>
		<dateModified>{DATE*}</dateModified>
		<ownerName>{$SITE_NAME*}</ownerName>
		<ownerEmail>{$STAFF_ADDRESS}</ownerEmail>
		<docs>http://www.opml.org/spec2/</docs>
	</head>
	<body>
		<outline type="link" text="{ABOUT*}" title="{$SITE_NAME*}" url="{$BASE_URL*}" />
		<outline text="Background">
			<outline text="{$STRIP_TAGS`,{!OPML_INDEX_DESCRIPTION}}" />
		</outline>
		<outline text="Atom">
			{+START,LOOP,FEEDS}
				<outline type="rss" language="{$LANG*}" version="Atom1.0" title="{$STRIP_TAGS`,{TITLE}}" text="{$STRIP_TAGS`,{TITLE}}" xmlUrl="{$FIND_SCRIPT*,backend}?type=atom&amp;mode={MODE*}&amp;days=30&amp;max=100{$KEEP*,0,1}" />
			{+END}
		</outline>
		<outline text="RSS">
			{+START,LOOP,FEEDS}
				<outline type="rss" language="{$LANG*}" version="RSS2" title="{$STRIP_TAGS`,{TITLE}}" text="{$STRIP_TAGS`,{TITLE}}" xmlUrl="{$FIND_SCRIPT*,backend}?type=RSS2&amp;mode={MODE*}&amp;days=30&amp;max=100{$KEEP*,0,1}" />
			{+END}
		</outline>
	</body>
</opml>
