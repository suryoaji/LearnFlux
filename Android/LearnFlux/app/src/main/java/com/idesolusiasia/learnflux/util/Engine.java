package com.idesolusiasia.learnflux.util;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import com.google.gson.Gson;
import com.idesolusiasia.learnflux.LoginActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.db.DatabaseFunction;
import com.idesolusiasia.learnflux.entity.BasicItem;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Thread;
import com.idesolusiasia.learnflux.entity.User;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by NAIT ADMIN on 07/06/2016.
 */
public class Engine {
	public static void login(final Context context, final String username, final String password,
	                         final RequestTemplate.ServiceCallback callback, final RequestTemplate.ErrorCallback errorCallback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_LOGIN);
		HashMap<String,String> params = new HashMap<>();
		params.put("username",username);
		params.put("password",password);
		params.put("grant_type","password");
		params.put("client_id",context.getString(R.string.client_id));
		params.put("client_secret",context.getString(R.string.client_secret));
		params.put("scope","internal");


		RequestTemplate.OAuth(context, url, params, new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try {
					User.getUser().setAccess_token(obj.getString("access_token"));
					User.getUser().setUsername(username);
					User.getUser().setPassword(password);
					//Functions.saveLastSync(context,"0");
					if (callback!=null){
						callback.execute(obj);
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}

			}
		}, new RequestTemplate.ErrorCallback() {
			@Override
			public void execute(JSONObject error) {
				if (error!=null){
					try {
						String message = error.getString("error_description");
						Toast.makeText(context, message.toString(),Toast.LENGTH_SHORT).show();
						if (errorCallback!=null){
							errorCallback.execute(error);
						}


					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			}

		});
	}

	public static void reLogin(final Context context, final RequestTemplate.ServiceCallback reDo){
		login(context, User.getUser().getUsername(), User.getUser().getPassword(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				getMe(context);
				if (reDo!=null){
					reDo.execute(obj);
				}

			}
		}, new RequestTemplate.ErrorCallback() {
			@Override
			public void execute(JSONObject error) {
				Intent i = new Intent(context, LoginActivity.class);
				i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP|Intent.FLAG_ACTIVITY_CLEAR_TASK);
				context.startActivity(i);

			}
		});
	}


	public static void getMe(final Context context){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+context.getString(R.string.URL_ME);
		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, null);
		}else {
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					try {
						Contact c = Converter.convertContact(obj);
						User.getUser().setUsername(c.getFirst_name()+" "+c.getLast_name());
						User.getUser().setID(c.getId());
						User.getUser().setEmail(c.getEmail());
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			},null);
		}

	}
	public static void getMeWithRequest(final Context context, final String query, final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+context.getString(R.string.URL_ME)+"/"+query;
		if(User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					getMeWithRequest(context,query,callback);
				}
			});
		}else{
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
				if(callback!=null){
					callback.execute(obj);
				}
				}
			},null);
		}
	}
	public static void getMyFriend(final Context context, final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+context.getString(R.string.URL_FRIEND);

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, null);
		}else {
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {

					if (callback!=null){
						callback.execute(obj);
					}
				}
			},null);
		}

	}

	public static void createThread(final Context context, final int[] ids, final String title, final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+context.getString(R.string.URL_MESSAGES);
		HashMap<String,int[]> par = new HashMap<>();
		par.put("participants",ids);
		JSONObject params = new JSONObject(par);
		try {
			params.put("title", title);
		} catch (JSONException e) {
			e.printStackTrace();
		}

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					createThread(context, ids, title, callback);
				}
			});
		}else {
			RequestTemplate.POSTJsonRequest(context, url, params, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if (obj!=null){

						try {
							Thread t = Converter.convertThread(obj.getJSONObject("data"));
							DatabaseFunction.insertSingleThread(context,t);
						} catch (JSONException e) {
							e.printStackTrace();
						}
						if (callback!=null){
							callback.execute(obj);
						}

					}

				}
			},null);
		}
	}

	public static void getThreads(final Context context, final RequestTemplate.ServiceCallback callback){
		String lastSync = Functions.getLastSync(context);
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_MESSAGES)+"?lastSync="+lastSync;
		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					getThreads(context,callback);
				}
			});
		}else {
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {

					try {
						Functions.saveLastSync(context,obj.getString("lastSync"));

						JSONArray array = obj.getJSONArray("data");
						ArrayList<Thread> arrThread = new ArrayList<Thread>();
						for(int i=0;i<array.length();i++){
							Thread t = Converter.convertThread(array.getJSONObject(i));
							arrThread.add(t);
						}
						List<Thread> fromDB = DatabaseFunction.getThreadList(context);

						//delete on DB threads that not in arrThread. because arrThread always give back all my valid thread.
						//if the thread is not in arrThread, it means we have no access to it anymore. it should be deleted from DB
						List<Thread> deletedThread = new ArrayList<Thread>();
						for (int i=0;i<fromDB.size();i++) {
							if (!Functions.isContainThread(fromDB.get(i),arrThread)){
								deletedThread.add(fromDB.get(i));
							}
						}
						DatabaseFunction.deleteThread(context,deletedThread);

						DatabaseFunction.insertThread(context,arrThread);
						if (callback!=null){
							callback.execute(obj);
						}
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			},null);
		}
	}


	public static void deleteThread(final Context context, final List<Thread> deleted,
	                                final RequestTemplate.ServiceCallback callback) {
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+context.getString(R.string.URL_MESSAGES);
		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					deleteThread(context,deleted,callback);
				}
			});
		}else {
			String[] ids = new String[deleted.size()];
			for (int i = 0; i < deleted.size(); i++) {
				ids[i]=deleted.get(i).getId();
			}
			HashMap<String,String[]> hashMap = new HashMap<>();
			hashMap.put("ids",ids);
			JSONObject params = new JSONObject(hashMap);
			RequestTemplate.DELETEJsonRequest(context, url, params, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					DatabaseFunction.deleteThread(context,deleted);
					if (obj!=null && callback!=null){
						callback.execute(obj);
					}

				}
			}, new RequestTemplate.ErrorCallback() {
				@Override
				public void execute(JSONObject error) {
					if (error!=null){
						try {
							JSONArray messages = error.getJSONObject("errors").getJSONArray("messages");
							Toast.makeText(context, messages.toString(), Toast.LENGTH_SHORT).show();
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}
				}
			});
		}
	}
	public static void registerUser(final Context context, final HashMap<String,String> par, final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_REGISTER);
		JSONObject params = new JSONObject(par);

		RequestTemplate.POSTJsonRequestWithoutAuth(context, url, params, new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				/*if (obj != null) {
					Log.i("response_POST_MSG", obj.toString());
					Intent i = new Intent(context,LoginActivity.class);
					i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP|Intent.FLAG_ACTIVITY_NEW_TASK);
					context.startActivity(i);
				}*/
				Functions.showAlertWithCallback(context, "Register",
						context.getString(R.string.success_registration),callback);
			}
		}, new RequestTemplate.ErrorCallback() {
			@Override
			public void execute(JSONObject error) {
				if (error!=null){
					try {
						//JSONArray messages = error.getJSONObject("errors").getJSONArray("messages");
						JSONArray errors = error.getJSONArray("errors");
						for(int i=0;i<errors.length();i++){
							JSONObject objs = errors.getJSONObject(i);
							String details = objs.getString("details");
							if(details.contains("Your password")){
								Functions.showAlert(context,"Errors", "Your password must have at least 8 characters");
							}else{
								Functions.showAlert(context, "Errors", details);
							}

						}

					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			}
		});
	}

	public static void getThreadMessages(final Context context, final RequestTemplate.ServiceCallback callback,
	                                     final String idThread){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_THREAD_MESSAGES,idThread);
		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					getThreadMessages(context, callback, idThread);
				}
			});
		}else {
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					try {
						JSONArray array = obj.getJSONArray("data");
						ArrayList<Thread> arrThread = new ArrayList<Thread>();
						for(int i=0;i<array.length();i++){
							Thread t = Converter.convertThread(array.getJSONObject(i));
							arrThread.add(t);
						}
						DatabaseFunction.insertThread(context,arrThread);
						if (callback!=null){
							callback.execute(obj);
						}

					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			},null);
		}
	}

	public static void sendMessage(final Context context, final String idThread, final String message, final String refID, final String refType, final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_THREAD_MESSAGES,idThread);

		JSONObject params = new JSONObject();
		try {
			params.put("body", message);
			if (refID!=null){
				JSONObject ref = new JSONObject();
				ref.put("id", refID);
				ref.put("type", refType);
				params.put("reference", ref);
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					sendMessage(context, idThread, message, refID, refType, callback);
				}
			});
		}else {
			RequestTemplate.POSTJsonRequest(context, url, params, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {

					if (obj!=null){
					}
					if (callback!=null){
						callback.execute(obj);
					}
				}
			},null);
		}
	}

	public static void createEvent(final Context context, final boolean useGroup, final String title, final String details, final String location,
	                               final long timestamp, final int[] participantIds, final String groupID, final String groupType,
	                               final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_EVENTS);

		JSONObject params = new JSONObject();
		try {
			params.put("title",title);
			params.put("details",details);
			params.put("location",location);
			params.put("timestamp",timestamp);
			if (useGroup){
				JSONObject ref = new JSONObject();
				ref.put("id",groupID);
				ref.put("type",groupType);
				params.put("reference",ref);
			}else {
				params.put("participants",participantIds);
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					createEvent(context, useGroup, title, details, location, timestamp, participantIds, groupID, groupType, callback);
				}
			});
		}else {
			RequestTemplate.POSTJsonRequest(context, url, params, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if (obj != null) {
					}
					if (callback != null) {
						callback.execute(obj);
					}

				}
			}, new RequestTemplate.ErrorCallback() {
				@Override
				public void execute(JSONObject error) {
					if (error!=null){
						try {
							//JSONArray messages = error.getJSONObject("errors").getJSONArray("messages");
							JSONArray errors = error.getJSONArray("errors");
							for(int i=0;i<errors.length();i++){
								JSONObject objs = errors.getJSONObject(i);
								String details = objs.getString("details");
								Toast.makeText(context, details, Toast.LENGTH_SHORT).show();
							}
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}
				}
			});
		}
	}

	public static void getOrganizations(final Context context,final RequestTemplate.ServiceCallback callback){
		String url = context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+context.getString(R.string.URL_GROUP);
		if(User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, null);
		}else{
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if (callback != null) {
						callback.execute(obj);
					}
						}

			},null);
		}
	}
	public static void getOrganizationProfile(final Context context, final String idGroup, final RequestTemplate.ServiceCallback callback){
		String url= context.getString(R.string.BASE_URL)+ context.getString(R.string.URL_VERSION)+ context.getString(R.string.URL_GROUP_PROFILE, idGroup);
		if(User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context,null);
		}else{
			RequestTemplate.GETJsonRequest(context,url,null,new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {

						if(callback!=null){
							callback.execute(obj);
						}
				}
			},null);
		}
	}


	public static void getEventById(final Context context, final String eventID,
	                                final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_EVENTS)+"/"+eventID;

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					getEventById(context, eventID, callback);
				}
			});
		}else {
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if (obj!=null){
					}
					if (callback!=null){
						callback.execute(obj);
					}

				}
			},null);
		}
	}

	public static void getGroupEventByGroupId(final Context context, final String groupId, final RequestTemplate.ServiceCallback callback)
	{
		String url = context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_ORGANIZATIONS)+"/"+groupId+ "/"+ context.getString(R.string.URL_EVENTS);

		if(User.getUser().getAccess_token().isEmpty()||User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					getGroupEventByGroupId(context, groupId,callback);
				}
			});
		}else{
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if(obj!=null){
					}if(callback!=null){
						callback.execute(obj);
					}
				}
			},null);
		}

	}
	public static void changeRSVPStatus(final Context context, final String eventID, final int RSVPStatus,
	                                final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_EVENTS)+"/"+eventID;

		JSONObject params = new JSONObject();
		try {
			params.put("rsvp",RSVPStatus);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Log.i("changeRSVPStatus", params.toString());

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					changeRSVPStatus(context, eventID, RSVPStatus, callback);
				}
			});
		}else {
			RequestTemplate.PUTJsonRequest(context, url, params, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if (obj!=null){
					}
					if (callback!=null){
						callback.execute(obj);
					}

				}
			},null);
		}
	}

	public static void createPoll(final Context context, final String title, final String question, final JSONArray options, final String idThread,
	                              final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_POLL);

		JSONObject params = new JSONObject();
		try {
			params.put("title",title);
			params.put("question",question);
			params.put("options",options);
		} catch (JSONException e) {
			e.printStackTrace();
		}

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					createPoll(context, title, question, options, idThread, callback);	}
			});
		}else {
			RequestTemplate.POSTJsonRequest(context, url, params, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if (obj!=null){

						try {
							sendMessage(context,idThread,User.getUser().getName()+" create a poll", obj.getJSONObject("data").getString("id"),"poll",callback);
						} catch (JSONException e) {
							e.printStackTrace();
						}

					}
					if (callback!=null){
						callback.execute(obj);
					}

				}
			},null);
		}
	}
	public static void createGroup(final Context context, final int[] ids, final String name,
	                               final String description, final String parentID, final String type,
	                               final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+context.getString(R.string.URL_GROUP);
		HashMap<String,int[]> par = new HashMap<>();
		par.put("participants",ids);
		JSONObject params = new JSONObject(par);
		try {
			params.put("name", name);
			params.put("description", description);
			if (parentID!=null){
				params.put("parent", parentID);
			}
			params.put("type", type);
		} catch (JSONException e) {
			e.printStackTrace();
		}

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					createGroup(context, ids, name, description, parentID, type, callback);
				}
			});
		}else {
			RequestTemplate.POSTJsonRequest(context, url, params, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if (obj != null) {

						try {
							Group g = Converter.convertGroup(obj.getJSONObject("data"));
							DatabaseFunction.insertSingleThread(context, g.getThread());
						} catch (JSONException e) {
							e.printStackTrace();
						}
						if (callback != null) {
							callback.execute(obj);
						}

					}

				}
			}, new RequestTemplate.ErrorCallback() {
				@Override
				public void execute(JSONObject error) {
					if(error!=null){
						try{
							JSONArray errors = error.getJSONArray("errors");
							for(int i=0;i<errors.length();i++){
								JSONObject err = errors.getJSONObject(i);
								String details = err.getString("details");
								Functions.showAlert(context,"errors", details);
							}

						}catch (JSONException e){
							e.printStackTrace();
						}
					}
				}
			});
		}
	}
	public static void postPollAnswer(final Context context, final String pollID, final String answerValue,
	                                    final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_POLL)+"/"+pollID;

		JSONObject params = new JSONObject();
		try {
			params.put("option",answerValue);
		} catch (JSONException e) {
			e.printStackTrace();
		}

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					postPollAnswer(context, pollID, answerValue, callback);
				}
			});
		}else {
			RequestTemplate.POSTJsonRequest(context, url, params, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if (obj!=null){
					}
					if (callback!=null){
						callback.execute(obj);
					}

				}
			},null);
		}
	}

	public static void getPollById(final Context context, final String pollID,
	                                final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_POLL)+"/"+pollID;

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					getPollById(context, pollID, callback);
				}
			});
		}else {
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if (obj!=null){
					}
					if (callback!=null){
						callback.execute(obj);
					}

				}
			},null);
		}
	}
	public static void getInterest(final Context context,
								   final RequestTemplate.ServiceCallback callback){
		String url = context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+"interests";

		if(User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					getInterest(context, callback);
				}
			});
		}else{
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if(obj!=null){
					}if(callback!=null){
						callback.execute(obj);
					}
				}
			},null);
		}
	}
	public static void editProfileName(final Context context, final String lastname, final String firstname,
									   final String location, final String work, final String token,
									   final RequestTemplate.ServiceCallback callback){
		String url = context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+context.getString(R.string.URL_ME);

		JSONObject params = new JSONObject();
		try {
			params.put("lastname", lastname);
			params.put("firstname", firstname);
			params.put("location", location);
			params.put("work", work);
			params.put("token", token);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		if(User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					editProfileName(context, lastname, firstname, location, work, token, callback);
				}
			});
		}else{
			RequestTemplate.PUTJsonRequest(context, url, params, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if(obj!=null){
					}if(callback!=null){
						callback.execute(obj);
					}
				}
			},null);
		}
	}
	public static void getNotification(final Context context, final RequestTemplate.ServiceCallback callback){
		String url = context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+"notifications";
		if(User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					getNotification(context, callback);
				}
			});
		}else{
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if(obj!=null){
					}if(callback!=null){
						callback.execute(obj);
					}
				}
			},null);
		}
	}
	public static void getUserFriend(final Context context, final int id,
									 final RequestTemplate.ServiceCallback callback){
		String url= context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+"user/"+String.valueOf(id)+"/friend";
		if(User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					getUserFriend(context, id, callback);
				}
			});
		}else{
			RequestTemplate.PATCHJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if (obj != null) {

					}
					if (callback != null) {
						callback.execute(obj);
					}
				}
			}, new RequestTemplate.ErrorCallback() {
				@Override
				public void execute(JSONObject error) {
					if (error!=null){
						try {
							//JSONArray messages = error.getJSONObject("errors").getJSONArray("messages");
							JSONArray errors = error.getJSONArray("errors");
							for (int i = 0; i < errors.length(); i++) {
								JSONObject objs = errors.getJSONObject(i);
								String details = objs.getString("details");
								Functions.showAlert(context, "Notification", details);
							}
						}catch (JSONException e) {
							e.printStackTrace();

						}
					}
				}
			});
			}
	}
	public static void getSearchValue(final Context context, final String firstname, final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+"search/"+firstname;
		if(User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					reLogin(context,callback);
				}
			});
		}else{
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if (obj != null) {
					}
					if (callback != null) {
						callback.execute(obj);
					}
				}
			}, new RequestTemplate.ErrorCallback() {
				@Override
				public void execute(JSONObject error) {
					if(error!=null){
						try {
							String message = error.getString("message");
							Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
						}catch (JSONException e){
							e.printStackTrace();
						}
					}
				}
			});
		}
	}
	public static void joinGroup(final Context context, final String groupID,
								 final String type, final RequestTemplate.ServiceCallback callback){
		String url = context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_GROUP)+"/"+groupID+"/"+"connect"+"/"+type;
		if(User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					joinGroup(context,groupID, type,callback);
				}
			});
		}else{
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if(obj!=null){
					}if(callback!=null){
						callback.execute(obj);
					}
				}
			},null);
		}
	}
	public static void putGroupByAdmin(final Context context, final String groupID, final int[] ids, final RequestTemplate.ServiceCallback callback){
		String url = context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_GROUP)+"/"+groupID;
		HashMap<String,int[]> par = new HashMap<>();
		par.put("include",ids);
		JSONObject params = new JSONObject();
		if(User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					putGroupByAdmin(context,groupID,ids,callback);
				}
			});
		}else{
			RequestTemplate.PUTJsonRequest(context, url, params, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if (obj!=null){

					}
					if (callback!=null){
						callback.execute(obj);
					}
				}
			},null);
		}
	}
	public static void queryWithUserId(final Context context, final String userID, final String query,
									   final RequestTemplate.ServiceCallback callback){
		String url = context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)
				     + "user/"+ userID + "/" + query;

		if(User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					queryWithUserId(context,userID,query,callback);
				}
			});
		}else {
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if(obj!=null){
					}if(callback!=null){
						callback.execute(obj);
					}
				}
			},null);
		}
	}
}
