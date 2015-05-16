{+START,IF,{$IN_STR,{CONTENT},<div}}<div style="{FACE*} {COLOR*} {SIZE*}">{CONTENT}</div>{+END}{+START,IF,{$NOT,{$IN_STR,{CONTENT},<div}}}<span style="{FACE*} {COLOR*} {SIZE*}">{CONTENT}</span>{+END}
