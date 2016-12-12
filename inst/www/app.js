$(document).ready(function() {
	$("#submitbutton").click(function(e){
		e.preventDefault()
		
		var b1 = document.getElementById('b1').value;
		var p1 = document.getElementById('p1').value;
		var mydata = [{friendly : b1, opponent: p1}];

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
