
	//set CORS to call "tvscore" package on public server
	//ocpu.seturl("public.opencpu.org/ocpu/github/gwang16/PickBan/R")

	//some example data
	//to run with different data, edit and press Run at the top of the page
$(document).ready(function() {
	$("#submitbutton").click(function(e){
		e.preventDefault()
		
		var mydata = [
	  {friendly : "Thresh", opponent: "Tristana"}
		];
		
		var req = ocpu.rpc("counterpick",{input : mydata}, function(output){
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
