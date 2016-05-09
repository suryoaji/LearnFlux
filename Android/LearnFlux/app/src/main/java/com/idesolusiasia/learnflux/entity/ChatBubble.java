package com.idesolusiasia.learnflux.entity;

import java.util.Calendar;

/**
 * Created by NAIT ADMIN on 20/04/2016.
 */
public class ChatBubble {
	private String type, sender, userPhoto, userName;
	private Calendar chatCalendar;

	ChatBubble(){}

	ChatBubble(String type, String sender, String userPhoto, String userName, Calendar chatCalendar){
		this.type=type;
		this.sender=sender;
		this.userPhoto=userPhoto;
		this.userName=userName;
		this.chatCalendar=chatCalendar;
	}

	public Calendar getChatCalendar() {
		return chatCalendar;
	}

	public void setChatCalendar(Calendar chatCalendar) {
		this.chatCalendar = chatCalendar;
	}

	public String getSender() {
		return sender;
	}

	public void setSender(String sender) {
		this.sender = sender;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserPhoto() {
		return userPhoto;
	}

	public void setUserPhoto(String userPhoto) {
		this.userPhoto = userPhoto;
	}
}
