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
<title>Lisaa vene</title>
</head>
<body>
<form id="tiedot">
	<table>
		<thead>	
			<tr>
				<th colspan="5" class="otsikko">Lisää uusi vene</th>
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
				<td><input type="text" name="nimi" id="nimi" placeholder="Veneen nimi"						size="18" style="font-size:13pt;height:26px"></td>
				<td><input type="text" name="merkkimalli" id="merkkimalli" placeholder="Veneen merkki/malli"size="18" style="font-size:13pt;height:26px"></td>
				<td><input type="text" name="pituus" id="pituus" placeholder="Pituus metreinä (3.2)"		size="18" style="font-size:13pt;height:26px"></td>
				<td><input type="text" name="leveys" id="leveys" placeholder="Pituus metreinä (1.5)"		size="18" style="font-size:13pt;height:26px"></td>
				<td><input type="text" name="hinta" id="hinta" placeholder="Hinta (11000)"					size="18" style="font-size:13pt;height:26px"></td>  
				<td><input type="submit" class="buttonadd" id="tallenna" value="Lisää"></td>
			</tr>
		</tbody>
	</table>
</form>
<span id="ilmo"></span>
</body>

<script>
$(document).ready(function(){
	
	//takaisin listaukseen -napin toiminta
	$("#takaisin").click(function(){
		document.location="listaaveneet.jsp";
	});
	
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
			lisaaTiedot();
		}		
	});
	//Viedään kursori nimi-kenttään sivun latauksen yhteydessä, koska käyttäjäystävällisyys
	$("#nimi").focus(); 
});
//funktio tietojen lisäämistä varten. Kutsutaan backin POST-metodia ja välitetään kutsun mukana uudet tiedot json-stringinä.
//POST /veneet/
function lisaaTiedot(){	
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //muutetaan lomakkeen tiedot json-stringiksi
	$.ajax({url:"veneet", data:formJsonStr, type:"POST", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}       
		if(result.response==0){
      	$("#ilmo").html("Veneen lisääminen epäonnistui.");
      }else if(result.response==1){			
      	$("#ilmo").html("Veneen  lisääminen onnistui.");
      	$("#Nimi", "#Merkkimalli", "#Pituus", "#Leveys", "#Hinta").val("");
		}
  }});	
}
</script>
</html>