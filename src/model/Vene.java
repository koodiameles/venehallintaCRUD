package model;

public class Vene {
	private int tunnus, hinta;			// tunnus toimii venetietokannassa primary key:na (autonumber)
	private String nimi, merkkimalli;
	private double pituus, leveys;
	
	
	public Vene() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Vene(int tunnus, int hinta, String nimi, String merkkimalli, double pituus, double leveys) {
		super();
		this.tunnus = tunnus;
		this.hinta = hinta;
		this.nimi = nimi;
		this.merkkimalli = merkkimalli;
		this.pituus = pituus;
		this.leveys = leveys;
	}

	public int getTunnus() {
		return tunnus;
	}

	public void setTunnus(int tunnus) {
		this.tunnus = tunnus;
	}

	public int getHinta() {
		return hinta;
	}

	public void setHinta(int hinta) {
		this.hinta = hinta;
	}

	public String getNimi() {
		return nimi;
	}

	public void setNimi(String nimi) {
		this.nimi = nimi;
	}

	public String getMerkkimalli() {
		return merkkimalli;
	}

	public void setMerkkimalli(String merkkimalli) {
		this.merkkimalli = merkkimalli;
	}

	public double getPituus() {
		return pituus;
	}

	public void setPituus(double pituus) {
		this.pituus = pituus;
	}

	public double getLeveys() {
		return leveys;
	}

	public void setLeveys(double leveys) {
		this.leveys = leveys;
	}

	@Override
	public String toString() {
		return "Vene [tunnus=" + tunnus + ", hinta=" + hinta + ", nimi=" + nimi + ", merkkimalli=" + merkkimalli
				+ ", pituus=" + pituus + ", leyveys=" + leveys + "]";
	}
	
	
	

	
	
	
}

