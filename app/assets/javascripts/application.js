// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require_tree .

//= require jquery_nested_form

$(function(){ $(document).foundation(); });

function requestAppChanged(appid) {
	// alert(appid);
	//$('#dynamic_get_form').empty().append('<ul> <%= j render @comments %> </li>');
	$.ajax({
	type: "GET",
	url: window.location.protocol+"//"+location.host+"/home/dynamic_form/",
	data: {
	    app_id: appid
	},
	dataType: "script"
  });
}

function requestApp(appid) {
	if(appid){
		window.location = "/home/submeter/" + appid
	}
}


function processCart(elem){

  var prodId = next(elem).value;
  var token = $("input[name='authenticity_token']").val();

  if ($("#portion_"+prodId).length > 0){
    var xportion = $("#portion_"+prodId).val();
  }
  if ($("#acompanhamento_"+prodId).length > 0){
    var xacompan = $("#acompanhamento_"+prodId).val();
  }
  
  $.ajax({
	type: "POST",
	url: window.location.protocol+"//"+location.host+"/home/add_to_cart/",
	data: {
	    id: prodId,
	    portion: xportion,
	    acompan: xacompan,
	    authenticity_token: token
	},
	dataType: "script"
  });
}

jQuery(document).ready(function() {

	$('#new_attachment').on('ajax:success', function(event, xhr, status) {
	  // insert the failure message inside the "#account_settings" element
	  // $(this).append(xhr.responseText)
	  alert('teste');
	});

	$('a').on('ajax:success', function(event, data, status, xhr) {
	  location.reload();
	});

	jQuery('.deploy').click(function() {
		//alert('ok');
		var app = $(this).attr('app');

		if (document.getElementById('tipoH_' + app).checked) {
		  radioValue = document.getElementById('tipoH_' + app).value;
		}else if (document.getElementById('tipoP_' + app).checked) {
		  radioValue = document.getElementById('tipoP_' + app).value;
		}

		window.location.href = '/deployer/deploy?app_id='+ app + '&op=D&tipo='+radioValue
	});

	jQuery('.action_app').click(function() {
		//alert('ok');
		var app = $(this).attr('app');
		var acao = $(this).attr('acao');

		if (document.getElementById('tipoH_' + app).checked) {
		  radioValue = document.getElementById('tipoH_' + app).value;
		}else if (document.getElementById('tipoP_' + app).checked) {
		  radioValue = document.getElementById('tipoP_' + app).value;
		}
		if(confirm('Tem certeza disso?')){
			window.location.href = '/deployer/deploy?app_id='+ app + '&op='+acao+'&tipo='+radioValue
		}
	});

});


