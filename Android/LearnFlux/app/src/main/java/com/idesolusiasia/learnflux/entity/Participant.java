package com.idesolusiasia.learnflux.entity;

import com.google.gson.annotations.SerializedName;

/**
 * Created by NAIT ADMIN on 28/06/2016.
 */
public class Participant {


	private int id;
	@SerializedName("first_name")
	private String firstName="First Name";
	private String lastName="";
	@SerializedName("profile_picture")
	private String photo="";
	private String type;
	private String link;

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

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getLink() {
		return link;
	}

	public void setLink(String link) {
		this.link = link;
	}
}
