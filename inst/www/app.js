$(document).ready(function() {
	$("#submitbutton").click(function(e){
		e.preventDefault()
		
		var t1 = document.getElementById('b1').val();
		var t2 = document.getElementById('p1').val();
		var mydata = [{friendly : t1, opponent: t2}];

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
