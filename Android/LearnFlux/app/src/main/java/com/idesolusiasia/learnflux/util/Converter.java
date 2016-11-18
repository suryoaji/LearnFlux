package com.idesolusiasia.learnflux.util;

import android.util.Log;

import com.google.gson.Gson;
import com.idesolusiasia.learnflux.entity.BasicItem;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.Event;
import com.idesolusiasia.learnflux.entity.FriendReq;
import com.idesolusiasia.learnflux.entity.Friends;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Member;
import com.idesolusiasia.learnflux.entity.MessageEvent;
import com.idesolusiasia.learnflux.entity.MessagePoll;
import com.idesolusiasia.learnflux.entity.Notification;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.entity.PeopleInvite;
import com.idesolusiasia.learnflux.entity.Poll;
import com.idesolusiasia.learnflux.entity.Thread;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by NAIT ADMIN on 13/06/2016.
 */
public class Converter {
	static Gson gson=new Gson();

	public static Thread convertThread(JSONObject obj)throws JSONException{
		Thread t = gson.fromJson(obj.toString(), Thread.class);
		if (obj.has("messages")){
			JSONArray messageArray = obj.getJSONArray("messages");
			for (int i=0;i<messageArray.length();i++) {
				JSONObject msg = messageArray.getJSONObject(i);
				if (msg.has("reference")){
					JSONObject ref = msg.getJSONObject("reference");
					if (ref.getString("type").equalsIgnoreCase("event")){
						t.getMessages().set(i,convertMessageEvent(msg));
					}else if (ref.getString("type").equalsIgnoreCase("poll")){
						t.getMessages().set(i,convertMessagePoll(msg));
					}
				}
			}
		}
		return t;
	}
	public static PeopleInvite convertInvite(JSONObject obj)throws JSONException{
		return gson.fromJson(obj.toString(), PeopleInvite.class);
	}
	public static Contact convertContact(JSONObject obj)throws JSONException{
		return gson.fromJson(obj.toString(),Contact.class);
	}
	public static Contact.Links convertLink(JSONObject obj)throws JSONException{
		return gson.fromJson(obj.toString(), Contact.Links.class);
	}
	public static FriendReq convertFriendRequest(JSONObject obj)throws JSONException{
		return gson.fromJson(obj.toString(), FriendReq.class);
	}
	public static Participant convertPeople(JSONObject obj)throws JSONException{
		return gson.fromJson(obj.toString(),Participant.class);
	}
	public static Group convertOrganizations(JSONObject obj)throws  JSONException {
		return gson.fromJson(obj.toString(), Group.class);
	}
	public static Notification convertNotification(JSONObject obj) throws JSONException{
		return gson.fromJson(obj.toString(),Notification.class);
	}

	public static MessageEvent convertMessageEvent(JSONObject obj)throws  JSONException{
		return gson.fromJson(obj.toString(), MessageEvent.class);
	}

	public static MessagePoll convertMessagePoll(JSONObject obj)throws  JSONException{
		return gson.fromJson(obj.toString(), MessagePoll.class);
	}

	public static Event convertEvent(JSONObject obj)throws  JSONException{
		return gson.fromJson(obj.toString(), Event.class);
	}

	public static Group convertGroup(JSONObject obj)throws  JSONException{
		return gson.fromJson(obj.toString(), Group.class);
	}

	public static Poll convertPoll(JSONObject obj)throws  JSONException{
		return gson.fromJson(obj.toString(), Poll.class);
	}
	public static Friends convertFriends(JSONObject obj)throws  JSONException{
		return gson.fromJson(obj.toString(), Friends.class);
	}
	public static Member convertMember(JSONObject obj)throws JSONException{
		return gson.fromJson(obj.toString(), Member.class);
	}
}
