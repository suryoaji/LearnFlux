package com.idesolusiasia.learnflux.entity;

import java.util.Calendar;

/**
 * Created by NAIT ADMIN on 21/04/2016.
 */
public class EventChatBubble extends ChatBubble {

	private Calendar timeStart, timeEnd;
	private String title, location, acceptanceStatus="";


	public EventChatBubble() {
		super();
	}

	public EventChatBubble(String type, String sender, String userPhoto, String userName, Calendar chatDate,
	                       String title, String location, String acceptanceStatus, Calendar timeStart, Calendar timeEnd){
		super(type, sender, userPhoto, userName, chatDate);
		this.title=title;
		this.location=location;
		this.acceptanceStatus =acceptanceStatus;
		this.timeStart = timeStart;
		this.timeEnd = timeEnd;
	}

	public Calendar getTimeEnd() {
		return timeEnd;
	}

	public void setTimeEnd(Calendar timeEnd) {
		this.timeEnd = timeEnd;
	}

	public Calendar getTimeStart() {
		return timeStart;
	}

	public void setTimeStart(Calendar timeStart) {
		this.timeStart = timeStart;
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

	public String getAcceptanceStatus() {
		return acceptanceStatus;
	}

	public void setAcceptanceStatus(String acceptanceStatus) {
		this.acceptanceStatus = acceptanceStatus;
	}
}
