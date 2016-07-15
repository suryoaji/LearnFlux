package com.idesolusiasia.learnflux.entity;

import java.util.Calendar;

/**
 * Created by NAIT ADMIN on 13/07/2016.
 */
public class Activity {
	private Calendar timeStart, timeEnd;
	private String title, location, description="";

	public Activity() {
		super();
	}

	public Activity(String type, String sender, String userPhoto, String userName, Calendar chatDate,
	                       String title, String location, Calendar timeStart, Calendar timeEnd){
		super();
		this.title=title;
		this.location=location;
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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
}
