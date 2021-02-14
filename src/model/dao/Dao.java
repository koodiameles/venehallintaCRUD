package model.dao;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.Vene;

public class Dao {
	private Connection con=null;
	private ResultSet rs = null;
	private PreparedStatement stmtPrep=null; 
	private String sql;
	private String db ="Venekanta.sqlite";	//tietokannan nimi
	
	
	// Yhdistä tietokantaan
	private Connection yhdista(){
    	Connection con = null;    	
    	String path = System.getProperty("catalina.base");    	
    	path = path.substring(0, path.indexOf(".metadata")).replace("\\", "/"); //Eclipsessa
    	//System.out.println("Polku on: " + path);
    	//path += "/webapps/"; //Tuotannossa. Laita kanta webapps-kansioon.
    	String url = "jdbc:sqlite:"+path+db;    	
    	try {	       
    		Class.forName("org.sqlite.JDBC");
	        con = DriverManager.getConnection(url);	
	        System.out.println("Yhteys avattu.");
	     }catch (Exception e){	
	    	 System.out.println("Yhteyden avaus epäonnistui.");
	        e.printStackTrace();	         
	     }
	     return con;
	}
	
	// Listaa kaikki veneet
	public ArrayList<Vene> listaaKaikki(){
		ArrayList<Vene> veneet = new ArrayList<Vene>();
		sql = "SELECT * FROM veneet";       
		try {
			con=yhdista();
			if(con!=null){ //jos yhteys onnistui
				stmtPrep = con.prepareStatement(sql);        		
        		rs = stmtPrep.executeQuery();   
				if(rs!=null){ //jos kysely onnistui									
					while(rs.next()){
						Vene vene = new Vene();
						vene.setTunnus((rs.getInt(1)));
						vene.setNimi(rs.getString(2)); 
						vene.setMerkkimalli(rs.getString(3));
						vene.setPituus(rs.getDouble(4));
						vene.setLeveys(rs.getDouble(5));
						vene.setHinta(rs.getInt(6));
						veneet.add(vene);
						}					
				}				
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return veneet;
	}
	
	// Listaa kaikki veneet HAKUSANAN mukaan
	public ArrayList<Vene> listaaKaikki(String hakusana){
		ArrayList<Vene> veneet = new ArrayList<Vene>();
		sql = "SELECT * FROM veneet WHERE nimi LIKE ? or merkkimalli LIKE ?";       
		try {
			con=yhdista();
			if(con!=null){ //jos yhteys onnistui
				stmtPrep = con.prepareStatement(sql);  
				stmtPrep.setString(1, "%" + hakusana + "%");
				stmtPrep.setString(2, "%" + hakusana + "%");    
        		rs = stmtPrep.executeQuery();   
				if(rs!=null){ //jos kysely onnistui							
					while(rs.next()){
						Vene vene = new Vene();
						vene.setTunnus((rs.getInt(1)));
						vene.setNimi(rs.getString(2)); 
						vene.setMerkkimalli(rs.getString(3));
						vene.setPituus(rs.getDouble(4));
						vene.setLeveys(rs.getDouble(5));
						vene.setHinta(rs.getInt(6));
						veneet.add(vene);
					}						
				}
				con.close();
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return veneet;
	}
	
	// Lisää vene tietokantaan
	public boolean lisaaVene(Vene vene){
		boolean paluuArvo=true;
		sql="INSERT INTO veneet(nimi, merkkimalli, pituus, leveys, hinta) VALUES(?,?,?,?,?)";						  
		try {
			con = yhdista();
			stmtPrep=con.prepareStatement(sql); 
			stmtPrep.setString(1, vene.getNimi());
			stmtPrep.setString(2, vene.getMerkkimalli());
			stmtPrep.setDouble(3, vene.getPituus());
			stmtPrep.setDouble(4, vene.getLeveys());
			stmtPrep.setInt(5, vene.getHinta());
			stmtPrep.executeUpdate();
			//System.out.println("Uusin id on " + stmtPrep.getGeneratedKeys().getInt(1));
	        con.close();
		} catch (SQLException e) {				
			e.printStackTrace();
			paluuArvo=false;
		}				
		return paluuArvo;
	}
	
	// Poista vene tietokannasta ("Oikeassa elämässä tiedot ensisijaisesti merkitään poistetuksi.")
	public boolean poistaVene(int tunnus){ 
		boolean paluuArvo=true;
		sql="DELETE FROM veneet WHERE tunnus=?";						  
		try {
			con = yhdista();
			stmtPrep=con.prepareStatement(sql); 
			stmtPrep.setInt(1, tunnus);			
			stmtPrep.executeUpdate();
	        con.close();
		} catch (SQLException e) {				
			e.printStackTrace();
			paluuArvo=false;
		}				
		return paluuArvo;
	}	
	
	// Etsi venettä
	public Vene etsiVene(int tunnus){
		Vene vene = null;
		sql = "SELECT * FROM veneet WHERE tunnus=?";       
		try {
			con=yhdista();
			if(con!=null){ 
				stmtPrep = con.prepareStatement(sql); 
				stmtPrep.setInt(1, tunnus);
        		rs = stmtPrep.executeQuery();  
        		if(rs.isBeforeFirst()){ //jos kysely tuotti dataa, eli tunnus on käytössä
        			//rs.next();
        			vene = new Vene(rs.getInt("tunnus"), rs.getInt("hinta"), rs.getString("nimi"), rs.getString("merkkimalli"), rs.getDouble("pituus"), rs.getDouble("leveys"));       			
				}	
        		con.close(); 
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return vene;		
	}
	
	// Muuta veneen tietoja
	public boolean muutaVene(Vene vene){
		boolean paluuArvo=true;
		sql="UPDATE veneet SET nimi=?, merkkimalli=?, pituus=?, leveys=?, hinta=? WHERE tunnus=?";		
		try {
			con = yhdista();
			stmtPrep=con.prepareStatement(sql); 
			stmtPrep.setString(1, vene.getNimi());
			stmtPrep.setString(2, vene.getMerkkimalli());
			stmtPrep.setDouble(3, vene.getPituus());
			stmtPrep.setDouble(4, vene.getLeveys());
			stmtPrep.setInt(5, vene.getHinta());
			stmtPrep.setInt(6, vene.getTunnus());
			stmtPrep.executeUpdate();
	        con.close();
		} catch (SQLException e) {				
			e.printStackTrace();
			paluuArvo=false;
		}				
		return paluuArvo;
	}
}