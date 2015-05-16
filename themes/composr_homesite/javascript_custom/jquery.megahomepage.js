/*{$,Parser hint: .innerHTML okay}*/
/*{$,Parser hint: pure}*/

(function($){
    var quoteCycler = {
        current: 0,
        delay: 5000,
        speed: 500,
        
        next: function(){
            if(this.current < (this.quotes.length - 1)){
                this.current++;
            } else {
                this.current = 0;
            }
            this.quotes.not('li:eq(' + this.current + ')').fadeOut(this.speed);
            this.quotes.filter('li:eq(' + this.current + ')').fadeIn(this.speed);
        },
        
        init: function(){
            this.context = $('#testimonial_scroller');
            if(this.context.length < 1){
                return false;
            }
            
            this.quotes = this.context.find('ul.quotes li');
            
            this.quotes.each(function(){
            	var blockquote = $(this).find('blockquote');
            	var blockquoteHeight = blockquote.outerHeight();
            	blockquote.css({
            		position: 'absolute',
            		top: '50%',
            		marginTop: -Math.ceil( ( blockquoteHeight/2 ) + 2 )/*,
            		left: 108*/
            	});
            });
            
            this.quotes.not('li:eq(0)').hide();
            
            setInterval(function(){
                quoteCycler.next();
            }, this.delay);
        }
    };
    
    var sdScrollTo = {
    	init: function(){
    		if( $('a.scrollto').length ){
    			$('a.scrollto').click(function(event){
    				event.preventDefault();
    				var href = $(this).attr('href');
    				$.scrollTo( $(href), 500, {offset: {top: 0} } )
    			});
    		}
    	}
    };
    
    var oobDemos = {
    	init: function(){
    		if( $('#oob_slidedeck_frame a.view-demo').length ){
    			$('#oob_slidedeck_frame a.view-demo').fancybox({
    				type: 'iframe',
    				padding: 0,
    				width: 820,
    				height: 600,
    				scrolling: 'no'
    			});
    		}
    	}
    };
    
    var stickyNav = {
    	init: function(){
    		var self = this;
    		if( $('#sticky_nav_wrapper').length ){
    			$('#sticky_nav_map_link').click(function(event){
    				event.preventDefault();
    			})
    			.mouseenter(function(){
    				$('#sticky_nav').animate({
						left: 0
					}, 150);
    			});
    			$('#sticky_nav').mouseleave(function(){
    				$('#sticky_nav').animate({
						left: -200
					}, 150);
    			});
    		}
    	}
    };
    
    
    $(document).ready(function(){
        quoteCycler.init();
        sdScrollTo.init();
        oobDemos.init();
        stickyNav.init();
        
        if($('a.fancy-image').length){
			$('a.fancy-image').fancybox({
    			padding: 0,
    			overlayOpacity: 0.7,
    			overlayColor: '#777'
			});
		}
        
    });
})(jQuery);