function detectTapatalk() {
	if (document.cookie.indexOf("tapatalk_redirect=false") < 0) {
		if (!navigator.userAgent.match(/Opera/i) && !navigator.userAgent.match(/Dolphin/i)) {
			if ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i))) {
				setTapatalkCookies();
				if (confirm("This forum has an app for iPhone and iPod Touch! Click OK to learn more about Tapatalk."))
					window.location = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=307880732&mt=8";
			} else if (navigator.userAgent.match(/iPad/i)) {
				setTapatalkCookies();
				if (confirm("This forum has an app for iPad! Click OK to learn more about Tapatalk."))
					window.location = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=307880732&mt=8";
			} else if (navigator.userAgent.match(/android/i)) {
				setTapatalkCookies();
				if (confirm("This forum has an app for Android phone! Click OK to learn more about Tapatalk."))
					window.location = "market://details?id=com.quoord.tapatalkpro.activity";
			} else if ((navigator.userAgent.match(/Windows Phone/i)) || (navigator.userAgent.match(/ZuneWP7/i))) {
				setTapatalkCookies();
				if (confirm("This forum is has an app for Windows Phone! Click OK to learn more about BoardExpress."))
					window.location = "zune://navigate/?phoneAppID=ac6eeb5d-e7da-df11-a844-00237de2db9e";
			} else if (navigator.userAgent.match(/webOS/i)) {
				setTapatalkCookies();
				if (confirm("This forum has an app for webOS phone! Click OK to learn more about Tapatalk."))
					window.location = "http://developer.palm.com/appredirect/?packageid=com.newnessdevelopments.forums";
			}
		}
	}
}

function setTapatalkCookies() {
	var date = new Date();
	var days = 90;
	date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
	var expires = "; expires=" + date.toGMTString();
	document.cookie = "tapatalk_redirect=false" + expires;
}

detectTapatalk();