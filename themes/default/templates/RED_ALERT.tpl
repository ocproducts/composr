<{+START,IF_PASSED_AND_TRUE,INLINE}span{+END}{+START,IF_NON_PASSED_OR_FALSE,INLINE}div{+END} class="red-alert"{+START,IF_PASSED,ROLE} role="role"{+END}>
	<span class="red-alert-icon">
		{+START,INCLUDE,ICON}
			NAME=status/notice
			ICON_SIZE=24
		{+END}
	</span>
	<span class="red-alert-message">{TEXT}</span>
</{+START,IF_PASSED_AND_TRUE,INLINE}span{+END}{+START,IF_NON_PASSED_OR_FALSE,INLINE}div{+END}>
