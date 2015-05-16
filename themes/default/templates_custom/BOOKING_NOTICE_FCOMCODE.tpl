The following booking(s) have been made...

[semihtml]{+START,INCLUDE,BOOKING_DISPLAY}{+END}[/semihtml]

You can [url="edit the bookings for {$USERNAME@,{MEMBER_ID}}"]{$PAGE_LINK@,_SEARCH:cms_booking:edit_booking:{MEMBER_ID},0,1}[/url].

{+START,IF,{$NOT,{$CONFIG_OPTION,member_booking_only}}}If there are any issues with this booking then it is important that you alert the customer.{+END}{+START,IF,{$CONFIG_OPTION,member_booking_only}}If there are any issues with this booking then it is important that you [url="alert the customer"]{$PAGE_LINK@,_SEARCH:topics:new_pt:{MEMBER_ID},0,1}[/url] ([url="view their details"]{$PAGE_LINK@,_SEARCH:members:view:{MEMBER_ID},0,1}[/url]).{+END}

The booking has been saved on the website, so if it has been cancelled then you should delete it, to make sure customers are not told unnecessarily that there are no places left.

You should keep this email so that you have a record of what your customer has been quoted for, even if your prices or services change since the original booking date.
The customer has been sent a similar email.
