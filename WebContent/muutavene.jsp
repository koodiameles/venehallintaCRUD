<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Muuta vene</title>
</head>
<body>
<form id="tiedot">
	<table>
		<thead>	
			<tr>
				<th colspan="5" class="otsikko">Muuta veneen tietoja</th>
				<th><input type="button" class="buttonwide" id="takaisin" value="Takaisin listaukseen"></th>
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
			<tr>
				<td><input type="text" name="nimi" id="nimi" 				size="18" style="font-size:13pt;height:26px"></td>
				<td><input type="text" name="merkkimalli" id="merkkimalli" 	size="18" style="font-size:13pt;height:26px"></td>
				<td><input type="text" name="pituus" id="pituus" 			size="18" style="font-size:13pt;height:26px"></td>
				<td><input type="text" name="leveys" id="leveys" 			size="18" style="font-size:13pt;height:26px"></td>
				<td><input type="text" name="hinta" id="hinta" 				size="18" style="font-size:13pt;height:26px"></td>  
				<td><input type="submit" class="buttonadd" id="tallenna" value="Päivitä"></td>
			</tr>
		</tbody>
	</table>
	<input type="hidden" name="tunnus" id="tunnus"> 
</form>
<span id="ilmo"></span>
</body>
<script>
$(document).ready(function(){
	
	//takaisin listaukseen -napin toiminta
	$("#takaisin").click(function(){
		document.location="listaaveneet.jsp";
	});
	
	$("#nimi").focus();//viedään kursori etunimi-kenttään sivun latauksen yhteydessä
	
	//Haetaan muutettavan veneen tiedot. Kutsutaan backin GET-metodia ja välitetään kutsun mukana muutettavan tiedon tunnus
	//GET /veneet/haeyksi/tunnus
	var tunnus = requestURLParam("tunnus"); //Funktio löytyy scripts/main.js 	
	$.ajax({url:"veneet/haeyksi/"+tunnus, type:"GET", dataType:"json", success:function(result){			
		$("#nimi").val(result.nimi);	
		$("#merkkimalli").val(result.merkkimalli);
		$("#pituus").val(result.pituus);
		$("#leveys").val(result.leveys);
		$("#hinta").val(result.hinta);
		$("#tunnus").val(result.tunnus);	
    }});
	
	//syötettyjen tietojen tarkistus
	$("#tiedot").validate({						
		rules: {
			nimi:  {
				required: true,
				minlength: 2				
			},	
			merkkimalli:  {
				required: true,
				minlength: 2				
			},
			pituus:  {
				required: true,
				number: true
			},	
			leveys:  {
				required: true,
				number: true
			},
			hinta:  {
				required: true,
				number: true
			}	
		},
		messages: {
			nimi: {     
				required: "Puuttuu",
				minlength: "Liian lyhyt"			
			},
			merkkimalli: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			pituus: {
				required: "Puuttuu",
				number: "Anna numeraalinen arvo. Esim 3.1"
			},
			leveys: {
				required: "Puuttuu",
				number: "Anna numeraalinen arvo. Esim 1.6"
			},
			hinta: {
				required: "Puuttuu",
				number: "Syötä hinnaksi numero esim. 15000"
			}
		},			
		submitHandler: function(form) {	
			paivitaTiedot();
		}		
	}); 	
});
//funktio tietojen päivittämistä varten. Kutsutaan backin PUT-metodia ja välitetään kutsun mukana uudet tiedot json-stringinä.
//PUT /veneet/
function paivitaTiedot(){	
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //muutetaan lomakkeen tiedot json-stringiksi
	$.ajax({url:"veneet", data:formJsonStr, type:"PUT", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}       
		if(result.response==0){
      	$("#ilmo").html("Veneen päivittäminen epäonnistui.");
      }else if(result.response==1){			
      	$("#ilmo").html("Veneen päivittäminen onnistui.");
	  }
  }});	
}


</script>
</html>