package com.idesolusiasia.learnflux.entity;

import java.util.Date;

/**
 * Created by NAIT ADMIN on 20/04/2016.
 */
public class ChatBubble {
	private String type, sender, userPhoto, userName;
	private Date chatDate;

	ChatBubble(){}

	public Date getChatDate() {
		return chatDate;
	}

	public void setChatDate(Date chatDate) {
		this.chatDate = chatDate;
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
}
