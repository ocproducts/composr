{CONTENT}

\{+START,IF_NON_EMPTY,{unsub_url}\}
-------------------------

[font size="0.8"]\{$?,\{$IS_EMPTY,\{member_id\}\},\{!NEWSLETTER_UNSUBSCRIBE_NEWSLETTER,\{unsub_url\}\},\{!NEWSLETTER_UNSUBSCRIBE_MEMBER,\{unsub_url\}\}\}[/font]
\{+END\}
