package com.idesolusiasia.learnflux.entity;

/**
 * Created by NAIT ADMIN on 28/06/2016.
 */
public class Participant {
	private int id;
	private String firstName="First Name";
	private String lastName;
	private String photo;


	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getPhoto() {
		return photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}
}
