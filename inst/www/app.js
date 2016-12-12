//ocpu.seturl("http://public.opencpu.org/ocpu/github/gwang16/PickBan/R")

$(document).ready(function() {

	$("#submitbutton").click(function(e){
		e.preventDefault()
		
		console.log($(":checked").val() == "1")

		if($(":checked").val() == "1"){
			var mydata = [{friendly : $("#b1").val(), opponent: $("#p1").val()}, 
			{friendly : $("#b2").val(), opponent: $("#p2").val()},
			{friendly : $("#b3").val(), opponent: $("#p3").val()},
			{friendly : $("#b4").val(), opponent: $("#p4").val()},
			{friendly : $("#b5").val(), opponent: $("#p5").val()}]
		} else {
			var mydata = [{friendly : $("#p1").val(), opponent: $("#b1").val()}, 
			{friendly : $("#p2").val(), opponent: $("#b2").val()},
			{friendly : $("#p3").val(), opponent: $("#b3").val()},
			{friendly : $("#p4").val(), opponent: $("#b4").val()},
			{friendly : $("#p5").val(), opponent: $("#b5").val()}]
		}

		console.log(mydata)

		var req = ocpu.rpc("counterpick", {input : mydata}, function(output){
	    	$("tbody").empty();
	    	$.each(output, function(index, value){
	      		var html = "<tr><td>" + value.champion + "</td><td>" + value.pwin + "</td><td>" + value.numGames + "</td></tr>";
	      		$("tbody").append(html);
			});
		});

		  //optional
		  req.fail(function(){
		    alert("R returned an error: " + req.responseText); 
		  });

	});
});
