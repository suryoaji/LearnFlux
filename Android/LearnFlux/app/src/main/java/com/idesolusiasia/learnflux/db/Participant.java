package com.idesolusiasia.learnflux.db;

/**
 * Created by NAIT ADMIN on 21/06/2016.
 */
public class Participant {
	private String ID, name, image;

	public String getID() {
		return ID;
	}

	public void setID(String ID) {
		this.ID = ID;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return name;
	}
}
