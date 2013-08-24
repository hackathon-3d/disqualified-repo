// JavaScript Document

;(function($) {

$(document).ready(function() {
	
	// WEATHER WIDGET
	var weatherOpen = false;
	$('.weather').click(function() {
		$('.weatherOver').animate({
			width: '100%'	
		}, 250, 'easeOutQuart');
		$('.nextGame').addClass('blur');
		$('.weather').addClass('blur');
		$('.buyTix').addClass('blur');
	});
	
	$('.weatherOver').click(function() {
		$('.weatherOver').animate({
			width: 0	
		}, 250, 'easeOutQuart');
		$('.nextGame').removeClass('blur');
		$('.weather').removeClass('blur');
		$('.buyTix').removeClass('blur');
	});




});

$(window).load(function() {
	

});

})(jQuery);