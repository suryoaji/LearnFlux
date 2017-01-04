package com.idesolusiasia.learnflux.fragment;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.ActionMode;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;

import com.idesolusiasia.learnflux.activity.ChattingActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.adapter.PeopleAdapter;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class ConnectionFragment extends Fragment {



	ListView listView;
	PeopleAdapter adap;

	public static ConnectionFragment newInstance() {
		ConnectionFragment fragment = new ConnectionFragment();
		return fragment;
	}

	public ConnectionFragment() {
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
	                         Bundle savedInstanceState) {
		View view = inflater.inflate(R.layout.fragment_connection, container, false);

		// Set the adapter
		if (view instanceof ListView) {
			Context context = view.getContext();
			listView= (ListView) view;
			getFriend();

			listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

				@Override
				public void onItemClick(AdapterView<?> adapterView, View view, final int position, long l) {
					int[] ids = new int[]{adap.getItem(position).getId()};
					Engine.createThread(getContext(), ids, adap.getItem(position).getFirstName(), new RequestTemplate.ServiceCallback() {
						@Override
						public void execute(JSONObject obj) {
							try {
								String id = obj.getJSONObject("data").getString("id");
								Intent i = new Intent(getContext(),ChattingActivity.class);
								i.putExtra("idThread",id);
								i.putExtra("name", adap.getItem(position).getFirstName());
								startActivity(i);
							} catch (JSONException e) {
								e.printStackTrace();
							}
						}
					});
				}
			});

			listView.setMultiChoiceModeListener(new AbsListView.MultiChoiceModeListener() {

				@Override
				public void onItemCheckedStateChanged(ActionMode mode, int position,
				                                      long id, boolean checked) {
					// Here you can do something when items are selected/de-selected,
					// such as update the title in the CAB
					adap.setSelected(position);
					adap.notifyDataSetChanged();
				}

				@Override
				public boolean onActionItemClicked(ActionMode mode, MenuItem item) {
					// Respond to clicks on the actions in the CAB
					switch (item.getItemId()) {
						case R.id.new_group:
							//deleteSelectedItems();
							showInputGroupName();
							mode.finish(); // Action picked, so close the CAB
							return true;
						default:
							return false;
					}
				}

				@Override
				public boolean onCreateActionMode(ActionMode mode, Menu menu) {
					// Inflate the menu for the CAB
					MenuInflater inflater = getActivity().getMenuInflater();
					inflater.inflate(R.menu.connection, menu);
					return true;
				}

				@Override
				public void onDestroyActionMode(ActionMode mode) {
					// Here you can make any necessary updates to the activity when
					// the CAB is removed. By default, selected items are deselected/unchecked.
					adap.clearSelection();
					adap.notifyDataSetChanged();
				}

				@Override
				public boolean onPrepareActionMode(ActionMode mode, Menu menu) {
					// Here you can perform updates to the CAB due to
					// an invalidate() request
					return false;
				}
			});
		}
		return view;
	}
	void getFriend() {
		Engine.getMeWithRequest(getContext(), "friends", new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try {
					JSONArray friends = obj.getJSONArray("friends");
					ArrayList<Participant> p = new ArrayList<Participant>();
					for (int i = 0; i < friends.length(); i++) {
						Participant participant = Converter.convertPeople(friends.getJSONObject(i));
						if (participant.getId() != User.getUser().getID()) {
							p.add(participant);
						}
					}
					if (p.size() > 0) {
						adap = new PeopleAdapter(getContext(), p);
						listView.setAdapter(adap);
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
		});
	}
	/*	Engine.getMyFriend(getContext(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try {
					JSONArray datas = obj.getJSONArray("data");
					ArrayList<Participant> p = new ArrayList<Participant>();
					for (int i=0;i<datas.length();i++){
						Participant participant = Converter.convertPeople(datas.getJSONObject(i));
						if (participant.getId()!= User.getUser().getID()){
							p.add(participant);
						}
					}

					if (p.size()>=0){
						adap = new PeopleAdapter(getContext(), p);
						listView.setAdapter(adap);
						DatabaseFunction.insertParticipant(getContext(),p);
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}

			}
		});
	}*/


	public void showInputGroupName(){
		final int[] ids = adap.getSelectedIds();

		final Dialog dialog = new Dialog(getContext());
		dialog.setTitle("Create Group");
		dialog.setContentView(R.layout.dialog_add_group);

		final EditText etName = (EditText) dialog.findViewById(R.id.add_group_name);
		final EditText etDesc = (EditText) dialog.findViewById(R.id.add_group_description);
		Button btnCancel = (Button) dialog.findViewById(R.id.btnCancel);
		Button btnSave = (Button) dialog.findViewById(R.id.btnNext);

		btnCancel.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				dialog.dismiss();
			}
		});

		btnSave.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				String textName = etName.getText().toString();
				String textDesc = etDesc.getText().toString();
				if (!textName.isEmpty()){
					Engine.createGroup(getContext(),ids,textName,textDesc,null,"group",new RequestTemplate.ServiceCallback() {
						@Override
						public void execute(JSONObject obj) {
							try {
								Group g = Converter.convertGroup(obj.getJSONObject("data"));
								String id = g.getThread().getId();
								Intent i = new Intent(getContext(),ChattingActivity.class);
								i.putExtra("idThread",id);
								startActivity(i);
							} catch (JSONException e) {
								e.printStackTrace();
							}

						}
					});
					dialog.dismiss();
				}
			}
		});
		dialog.show();
	}

}
