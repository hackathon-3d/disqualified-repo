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


function updateWeather(data)
{

}

function setTeamInformation(data)
{
	alert(data);
}

function setTeamColors(baseColor, accentColor)
{
	// Base Colors
	$('.baseColorBorder').css('border-color', baseColor);
	$('.baseColorText').css('color', baseColor);
	$('.baseColorBg').css('background-color', baseColor);
	$('.baseColorLink a').css('color', baseColor + '!important');
	$('.twitterContent a').css('color', baseColor + '!important');

	// Accent Colors
	$('.accentColorBorder').css('border-color', accentColor);
	$('.accentColorText').css('color', accentColor);
	$('.accentColorBg').css('background-color', accentColor);
	$('.accentColorLink a').css('color', accentColor + '!important');


}