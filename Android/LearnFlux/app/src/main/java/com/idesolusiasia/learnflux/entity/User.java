package com.idesolusiasia.learnflux.entity;

/**
 * Created by NAIT ADMIN on 07/06/2016.
 */
public class User {
	private static User u;
	private String access_token, name, email, phone, password, username;

	private User(){
		access_token="";
		name="";
		email="";
		phone="";
		password="";
		username="";
	}

	public static synchronized User getUser() {
		if (u == null) {
			u = new User();
		}
		return u;
	}

	public String getAccess_token() {
		return access_token;
	}

	public void setAccess_token(String access_token) {
		this.access_token = access_token;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
}
