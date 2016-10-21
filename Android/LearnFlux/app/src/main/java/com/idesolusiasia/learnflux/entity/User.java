package com.idesolusiasia.learnflux.entity;

import java.util.List;

/**
 * Created by NAIT ADMIN on 07/06/2016.
 */
public class User {
	private static User u;
	private int ID;
	private String access_token;
	private String name;
	private String email;
	private String phone;
	private String password;
	private String username;
	private String profile_picture;
	private List<User>friend_request;
	private String interests;

	private User(){
		access_token="57453e293a603f8c168b4567_5gj7ywf0ocsoosw0sc8sgsgk8gckkc80o8co8gg00o08g88c4o";
		name="";
		email="";
		phone="";
		password="";
		username="";
		profile_picture="";
		interests="";
		ID=0;
	}

	public static synchronized User getUser() {
		if (u == null) {
			u = new User();
		}
		return u;
	}

	public List<User> getFriendRequest() {
		return friend_request;
	}

	public void setFriend_request(List<User> friend_request) {
		this.friend_request = friend_request;
	}

	public int getID() {
		return ID;
	}

	public void setID(int ID) {
		this.ID = ID;
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
	public String getProfile_picture() {
		return profile_picture;
	}

	public void setProfile_picture(String profile_picture) {
		this.profile_picture = profile_picture;
	}

	public String getInterests() {
		return interests;
	}

	public void setInterests(String interests) {
		this.interests = interests;
	}

}
