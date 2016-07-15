package com.idesolusiasia.learnflux.entity;

/**
 * Created by NAIT ADMIN on 01/07/2016.
 */
public class Group {
	private String name, ID, detail;

	public Group() {
	}

	public Group( String ID, String name, String detail) {
		this.detail = detail;
		this.ID = ID;
		this.name = name;
	}

	public String getDetail() {
		return detail;
	}

	public void setDetail(String detail) {
		this.detail = detail;
	}

	public String getID() {
		return ID;
	}

	public void setID(String ID) {
		this.ID = ID;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}
