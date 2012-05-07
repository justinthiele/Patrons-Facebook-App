// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
	$("table#pledges-table").tablesorter({ sortList: [[3,1]] });
	
	$("#pledges-table-div").insertAfter("#table_heading");

	$("div#header").insertBefore("div#notice-bar");


	// $("#paypal_fields").insertAfter("#PayPal");
	
});

// $(document).ready(function() {
//   if ($("#artist_payment_method_paypal").is(':checked')) {
//     $("#artist_payment_name, #artist_address_line1, #artist_address_line2, #artist_address_city, #artist_address_state, #artist_address_zip, #artist_address_country").attr("disabled","disabled");
//   } else {
//     $("#artist_paypal_email").attr("disabled","disabled");
//   }
// 
//   $("#artist_payment_method_paypal").click(function(){
//   $("#artist_paypal_email").removeAttr("disabled");
//   $("#artist_payment_name, #artist_address_line1, #artist_address_line2, #artist_address_city, #artist_address_state, #artist_address_zip, #artist_address_country").attr("disabled","disabled");
//   }),
//   $("#artist_payment_method_check").click(function(){
//   $("#artist_paypal_email").attr("disabled","disabled");
//   $("#artist_payment_name, #artist_address_line1, #artist_address_line2, #artist_address_city, #artist_address_state, #artist_address_zip, #artist_address_country").removeAttr("disabled");
//   });
// });


$(function() {
	$('.uiButton, .fb_button_text').click(function() {
		$(this).text("loading...");
	});
});

$(function() {
	$('.uiButtonConfirm').click(function() {
		$(this).attr( "value", "loading..." );
	});
});

$(function () {
	$("div[rel=popover]").popover({offset: -280})
});