package com.idesolusiasia.learnflux.entity;

import java.util.Calendar;

/**
 * Created by NAIT ADMIN on 21/04/2016.
 */
public class EventChatBubble extends ChatBubble {

	private Calendar dateTime;
	private String title, location, aceeptanceStatus;


	public EventChatBubble() {
		super();
	}

	public Calendar getDateTime() {
		return dateTime;
	}

	public void setDateTime(Calendar dateTime) {
		this.dateTime = dateTime;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
}
