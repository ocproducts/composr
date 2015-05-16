/*{$,Parser hint: .innerHTML okay}*/
/*{$,Parser hint: pure}*/

/*
 * 	Vertical Tabs 1.1- jQuery plugin
 *	written by Kent Heberling, http://www.khwebdesign.net	
 *	http://khwebdesign.net/blog/vertical-tabs-a-jquery-plugin/
 *
 *	Copyright (c) 2010 Kent Heberling(http://www.khwebdesign.net)
 *	Dual licensed under the MIT (MIT-LICENSE.txt)
 *	and GPL (GPL-LICENSE.txt) licenses.
 *
 *	Built for jQuery library
 *	http://jquery.com
 *
 */
 
/*
	<div class="verticalslider">
        <ul class="verticalslider_tabs">
            <li><a href="#">Tab 1</a></li>
            <li><a href="#">Tab 2</a></li>                     
        </ul>
        <ul class="verticalslider_contents">
            <li>Content 1</li>
            <li>Content 2</li>                       
        </ul>
    </div> 
 */
 
 /* TO DO

 */
(function($){  
 $.fn.verticaltabs = function(options) {  
 	 // Default Values
	 var defaults = {  
		speed: 500,
		slideShow: true,
		slideShowSpeed: 1000,
		activeIndex: 0,
		playPausePos: "bottomRight",
		pauseOnHover: true
	 };  
	 var options = $.extend(defaults, options);  
	   
	 // Main Plugin Code	 
	 return this.each(function() {  
		var verticaltabs = $(this);
		var tabs = $(verticaltabs).children(".verticalslider_tabs").children(); // all of the tabs
		var contents = $(verticaltabs).children(".verticalslider_contents").children(); // all of the contents
		var sliderInterval;
		var arrowBlock = "<div class=\"arrow\">&nbsp;</div>";
		var activeIndex = defaults.activeIndex;
		var slideShow = options.slideShow;
		var timeout;
		var totalHeight;
		
		// Initializing Code
		$(contents[defaults.activeIndex]).addClass("activeContent");
		$(tabs[activeIndex]).addClass("activeTab").append(arrowBlock); // Set first tab and first content to active
		totalHeight = $(tabs).length * $(".verticalslider_tabs a").outerHeight(); // Calculate total height for use in playPause positioning and content overflow		
		$(".verticalslider_contents>li",verticaltabs).css({height: totalHeight + "px"}); // Assign height to contents to prevent content overflow
		
		if (options.slideShow){ // Show play/pause if in slideshow mode
			$(verticaltabs).children(".verticalslider_contents").append("<div class=\"playPause\"><div class=\"play\"><a href=\"#\"></a></div><div class=\"pause\"><a href=\"#\"></a></div></div>");	
			switch (options.playPausePos){
				case "topRight":
					$(".verticalslider .playPause").css({marginTop: "0px", marginLeft: $(".verticalslider_contents").width()-$(".verticalslider .playPause a").width()});
					break;
				case "topLeft":
					$(".verticalslider .playPause").css({marginTop: "0px", marginLeft: "0px"});
					break;
				case "bottomRight":
					$(".verticalslider .playPause").css({marginTop: totalHeight-$(".verticalslider .playPause a").height(), marginLeft: $(".verticalslider_contents").width()-$(".verticalslider .playPause a").width()});
					break;
				case "bottomLeft":
					$(".verticalslider .playPause").css({marginTop: totalHeight-$(".verticalslider .playPause a").height(), marginLeft: "0px"});
					break;					
			}
		}
		
		// Event Bindings
		$(".verticalslider_tabs a", verticaltabs).click(function (){	
			if (!$(this).parent().hasClass("activeTab")){ // do nothing if the clicked tab is already the active tab
				activeIndex	= $(this).parent().prevAll().length; // a clicked -> li -> previous siblings
				switchContents();
				if (slideShow){	
					clearTimeout(timeout);
					slideShow = false;
					$(".pause a", verticaltabs).css("display","none"); // pause slideshow if currently in slideshow mode
					$(".play a", verticaltabs).css("display","block"); // pause slideshow if currently in slideshow mode
				}
			}
			return false;
		});
		
		$(".play, .pause", verticaltabs).click(function (){	
			slideShow = !slideShow; // Toggle slideshow mode
			$(".play a, .pause a", verticaltabs).toggle();	// Toggle play/pause buttons
			if (slideShow){
				startSlideShow();
			}
			return false;			
		});	

		// Pause on hover option
		$(tabs).add(contents).hover(function (){
			if (options.pauseOnHover && slideShow){
				slideShow = !slideShow;
			}
			},function () {
			if (options.pauseOnHover && !slideShow && $(".pause a",verticaltabs).is(":visible")){			
				startSlideShow();
				}
			}
		);

		
		// Plugin Methods
		function switchContents() {	
			$(".activeTab", verticaltabs).removeClass("activeTab");
			$('.arrow', verticaltabs).remove();
			$(tabs[activeIndex], verticaltabs).addClass("activeTab").append(arrowBlock);	// Update tabs	
			$(".activeContent", verticaltabs).fadeOut(options.speed).removeClass("activeContent");
			$(contents[activeIndex], verticaltabs).fadeIn(options.speed).addClass("activeContent"); // Update content
		};
		
		function startSlideShow(){
			slideShow = true;
			clearTimeout(timeout); // incase the timeout was set multiple times by means of propagation
			timeout = setTimeout(function(){autoUpdate();}, options.speed + options.slideShowSpeed);
		}

		function autoUpdate() {	
			if (slideShow){	
				activeIndex++;
				if (activeIndex == contents.length){activeIndex = 0;}
				switchContents();
				startSlideShow(); // Call this again
			}			
		};	
		
		// Timed Events
		if (slideShow){
			timeout = setTimeout(function(){autoUpdate();}, options.speed + options.slideShowSpeed); // Begin the autoUpdate
		}
	 }); 
 };  
})(jQuery);  



