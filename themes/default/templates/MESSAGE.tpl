<div class="box box---message box---message-{TYPE*}"><div class="box-inner">{$,Possible {TYPE}s: 'notice', 'inform', 'warn'}
	<div class="global-message global-message-{TYPE*}" role="alert">
		{+START,INCLUDE,ICON}
			NAME=status/{TYPE}
			ICON_SIZE=24
			ICON_CLASS=global-message-icon
		{+END}

		<div class="global-message-text">{MESSAGE}</div>
	</div>
</div></div>
