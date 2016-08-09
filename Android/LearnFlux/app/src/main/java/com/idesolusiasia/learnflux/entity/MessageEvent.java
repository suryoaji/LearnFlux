package com.idesolusiasia.learnflux.entity;

import com.google.gson.annotations.SerializedName;

/**
 * Created by NAIT ADMIN on 05/08/2016.
 */
public class MessageEvent extends Message {
	@SerializedName("reference")
	private Event event;

	public MessageEvent() {
	}

	public Event getEvent() {
		return event;
	}

	public void setEvent(Event event) {
		this.event = event;
	}
}
