$(document).ready(function() {

	$("#submitbutton").click(function(e){
		e.preventDefault()
		
		if($("input[id=team]:checked").val() == 1){
			t1 = "friendly"
			t2 = "opponent"
		} else {
			t1 = "opponent"
			t2 = "friendly"
		}

		var mydata = [
		{t1 : $("#b1").val(), t2: $("#p1").val()},
		{t1 : $("#b2").val(), t2: $("#p2").val()},
		{t1 : $("#b3").val(), t2: $("#p3").val()},
		{t1 : $("#b4").val(), t2: $("#p4").val()},
		{t1 : $("#b5").val(), t2: $("#p5").val()},
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
