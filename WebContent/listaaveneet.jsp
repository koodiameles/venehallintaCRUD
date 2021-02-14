<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Veneiden listaus</title>
</head>
<body>
	<table id="listaus">
		<thead>	
			<tr>
				<th colspan="5" class="otsikko">Venehallinta</th>
				<th><input type="button" class="buttonadd" id="uusiVene" value="Lis�� uusi vene"></th>

			</tr>
			<tr>
				<th style="font-size:16pt">Venehaku</th>
				<th colspan="4"><input type="text" id="hakusana" placeholder="Hae nimen tai mallin mukaan" size="30" style="font-size:14pt;height:32px"></th>
				<th><input type="button" class="buttonwide" id="hae" value="Hae"></th>
			</tr>		
			<tr>
				<th>Nimi</th>
				<th>Merkkimalli</th>
				<th>Pituus</th>
				<th>Leveys</th>	
				<th>Hinta</th>
				<th>&nbsp;</th>				
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
<script>
$(document).ready(function(){
	
	//uusivene -napin toiminta
	$("#uusiVene").click(function(){
		document.location="lisaavene.jsp";
	});
	//n�pp�imist�n komentojen vastaanotto
	$(document.body).on("keydown", function(event){
		  if(event.which==13){ //Enteri� painettu, ajetaan haku
			  haeTiedot();
		  }
	});	
	//hae -napin toiminta
	$("#hae").click(function(){	
		haeTiedot();
	});
	//muuta
	$("#hakusana").focus();//vied��n kursori hakusana-kentt��n sivun latauksen yhteydess�
	haeTiedot();
});

////////////
//FUNKTIOT//
////////////

//hae veneiden tiedot esille
function haeTiedot(){	
	$("#listaus tbody").empty();
	$.getJSON({url:"veneet/"+$("#hakusana").val(), type:"GET", dataType:"json", success:function(result){	
		$.each(result.veneet, function(i, field){  
        	var htmlStr;
        	htmlStr+="<tr id='rivi_"+field.tunnus+"'>";
        	htmlStr+="<td>"+field.nimi+"</td>";
        	htmlStr+="<td>"+field.merkkimalli+"</td>";
        	htmlStr+="<td>"+field.pituus+"</td>";
        	htmlStr+="<td>"+field.leveys+"</td>"; 
        	htmlStr+="<td>"+field.hinta+"</td>";
        	
        	// vaihda nimen/merkkimallin " " -v�lily�nnit &nbsp -v�lily�nneiksi. (Ilman t�t� poistofunktio ei toimi v�lily�ntej� sis�lt�viin veneisiin koska javascript)
        	field.nimi = field.nimi.replace(" ", "&nbsp;")	
        	field.merkkimalli = field.merkkimalli.replace(" ", "&nbsp;")
        	
        	//Napit jokaisen veneen per��n (Muuta ja Poista)
        	htmlStr+="<td><button class='button' onclick=muuta("+field.tunnus+")>Muuta</button>";
        	htmlStr+="<button class='buttondel' onclick=poista("+field.tunnus+",'"+field.nimi+"','"+field.merkkimalli+"')>Poista</button></td>";
        	
        	/* 
        	vanhat tekstilinkit 'muuta' ja 'poista' -toiminoille. T�m�n voisi poistaa t��lt�, mutta j�tin itse� varten muistiin esille.
        		htmlStr+="<td><a href='muutavene.jsp?tunnus="+field.tunnus+"'>Muuta</a>&nbsp;";
        		htmlStr+="<span class='poista' onclick=poista("+field.tunnus+",'"+field.nimi+"')>Poista</span>"; 
        	*/
        	$("#listaus tbody").append(htmlStr);
        });
    }});	
}

//Poista napin toimintafunktio
function poista(tunnus, nimi, merkkimalli){
	if(confirm("Poista " + nimi + ", " + merkkimalli + "?")){
		$.ajax({url:"veneet/"+tunnus, type:"DELETE", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}
	        if(result.response==0){
	        	$("#ilmo").html("Veneen poisto ep�onnistui.");
	        }else if(result.response==1){
	        	$("#rivi_"+tunnus).css("background-color", "red"); //V�rj�t��n poistetun veneen rivi
	        	alert("Veneen " + nimi + " poisto onnistui.");
				haeTiedot();        	
			}
	    }});
	}
}

//Muuta napin toimintafunktio
function muuta(tunnus){
	location.href="muutavene.jsp?tunnus="+tunnus
}

</script>
</body>
</html>