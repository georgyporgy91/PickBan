$(document).ready(function() {

	$("#submitbutton").click(function(e){
		e.preventDefault()
		
		//if($("input[name=team]:checked", "#myform").val() == 1){
		//	t1 = "friendly"
		//	t2 = "opponent"
		//} else {
		//	t1 = "opponent"
		//	t2 = "friendly"
		//}

		var mydata = [
		{friendly : $("#b1").val(), opponent: $("#p1").val()},
		{friendly : $("#b2").val(), opponent: $("#p2").val()},
		{friendly : $("#b3").val(), opponent: $("#p3").val()},
		{friendly : $("#b4").val(), opponent: $("#p4").val()},
		{friendly : $("#b5").val(), opponent: $("#p5").val()},
		];

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
