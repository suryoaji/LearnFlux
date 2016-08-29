package com.idesolusiasia.learnflux.entity;

import com.google.gson.annotations.SerializedName;
import com.idesolusiasia.learnflux.util.Functions;

import java.util.List;

/**
 * Created by NAIT ADMIN on 05/08/2016.
 */
public class Event {

	private String id;
	private long timestamp;
	private String details;
	private String location;
	private String title;
	@SerializedName("rsvp")
	private int getEventByGroupRSVP;

	private String type;

	public int getGetEventByGroupRSVP() {
		return getEventByGroupRSVP;
	}

	public void setGetEventByGroupRSVP(int getEventByGroupRSVP) {
		this.getEventByGroupRSVP = getEventByGroupRSVP;
	}

	private Participant created_by;
	private Thread thread;

	private List<ParticipantEvent> participants;

	public Event() {
	}

	public Event(String details, String id, String location, long timestamp, String title) {
		this.details = details;
		this.id = id;
		this.location = location;
		this.timestamp = timestamp;
		this.title = title;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public long getTimestamp() {
		return timestamp;
	}

	public String getTimestampDate() {
		return Functions.convertSecondToDate(timestamp);
	}

	public void setTimestamp(long timestamp) {
		this.timestamp = timestamp;
	}

	public String getDetails() {
		return details;
	}

	public void setDetails(String details) {
		this.details = details;
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

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Participant getCreated_by() {
		return created_by;
	}

	public void setCreated_by(Participant created_by) {
		this.created_by = created_by;
	}

	public Thread getThread() {
		return thread;
	}

	public void setThread(Thread thread) {
		this.thread = thread;
	}

	public List<ParticipantEvent> getParticipants() {
		return participants;
	}

	public void setParticipants(List<ParticipantEvent> participants) {
		this.participants = participants;
	}


	public static class ParticipantEvent {

		private Participant user;
		private int rsvp;

		public Participant getUser() {
			return user;
		}

		public void setUser(Participant user) {
			this.user = user;
		}

		public int getRsvp() {
			return rsvp;
		}

		public void setRsvp(int rsvp) {
			this.rsvp = rsvp;
		}
	}

	public int getRSVPByParticipantID(int id){
		for (ParticipantEvent participant:participants) {
			if (participant.getUser().getId()==id){
				return participant.getRsvp();
			}

		}
		return -1;
	}
}
