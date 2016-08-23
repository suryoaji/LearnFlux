package com.idesolusiasia.learnflux;

import android.app.Dialog;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.util.SparseBooleanArray;
import android.view.ActionMode;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import com.idesolusiasia.learnflux.adapter.AddGroupAdapter;
import com.idesolusiasia.learnflux.adapter.InterestGroupAdapter;
import com.idesolusiasia.learnflux.adapter.OrganizationGridRecyclerViewAdapter;
import com.idesolusiasia.learnflux.adapter.PeopleAdapter;
import com.idesolusiasia.learnflux.db.DatabaseFunction;
import com.idesolusiasia.learnflux.entity.Activity;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.ItemOffsetDecoration;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Ide Solusi Asia on 8/15/2016.
 */
public class InterestGroup extends AppCompatActivity {

    ArrayList<Group> arrOrg = new ArrayList<Group>();
    public Participant participant=null;
    private GridLayoutManager lLayout;
    InterestGroupAdapter rcAdapter;
    RecyclerView recyclerView;
    AddGroupAdapter adap;
    public String name,desc;
    ListView listcontent;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_group_interest);
        recyclerView = (RecyclerView)findViewById(R.id.recycler_group_interest);
        lLayout = new GridLayoutManager(getApplicationContext(),2);
        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(lLayout);
        ItemOffsetDecoration itemDecoration = new ItemOffsetDecoration(getApplicationContext(), R.dimen.item_offset);
        recyclerView.addItemDecoration(itemDecoration);
        initGroup();
    }
    private void initGroup(){
        arrOrg = new ArrayList<>();
        Engine.getOrganizations(getApplicationContext(), new RequestTemplate.ServiceCallback() {
            @Override
            public void execute(JSONObject obj) {

                try{
                    JSONArray array = obj.getJSONArray("data");
                    for(int i=0;i<array.length();i++){
                        Group org = Converter.convertOrganizations(array.getJSONObject(i));
                        if(array.getJSONObject(i).getString("type").equals("group")) {
                            arrOrg.add(org);
                        }
                    }
                    rcAdapter = new InterestGroupAdapter(InterestGroup.this,arrOrg);
                    recyclerView.setAdapter(rcAdapter);
                }catch (JSONException e){
                    e.printStackTrace();
                }

            }
        });
    }
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.interest_menu_creategroup, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        switch(item.getItemId()){
            case R.id.new_group:
                addInterestNewGroup();
                return true;
        }

        return super.onOptionsItemSelected(item);
    }
    public void addInterestNewGroup(){
        final Dialog dialog = new Dialog(InterestGroup.this);
        dialog.setTitle("Add new Group");
        dialog.setContentView(R.layout.dialog_add_group);
        final EditText groupName = (EditText) dialog.findViewById(R.id.add_group_name);
        final EditText groupDesc = (EditText) dialog.findViewById(R.id.add_group_description);
        Button btnNext = (Button)dialog.findViewById(R.id.btnNext);
        Button cancel = (Button)dialog.findViewById(R.id.btnCancel);
        btnNext.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
               name = groupName.getText().toString().trim();
               desc = groupDesc.getText().toString().trim();
               OpenDialog2();
            }
        });
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialog.dismiss();
            }
        });
        dialog.show();
    }
    void OpenDialog2(){
		final Dialog dial = new Dialog(InterestGroup.this);
		dial.setTitle("Add participant");
		dial.setContentView(R.layout.layout_dialog);

		listcontent = (ListView) dial.findViewById(R.id.alert_list);
        Button next = (Button)dial.findViewById(R.id.btnNext);
        Button cancel = (Button)dial.findViewById(R.id.btnCancel);
        next.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String result = "";
                for (Participant p : adap.getBox()) {
                    if (p.box){
                        result += "\n" + p.getId();
                        int[] ids = new int[]{p.getId()};
                        Engine.createGroup(getApplicationContext(), ids, name, desc, null,
                                "group", new RequestTemplate.ServiceCallback() {
                                    @Override
                                    public void execute(JSONObject obj) {
                                    Toast.makeText(getApplicationContext(), "successfull", Toast.LENGTH_SHORT).show();
                                    dial.dismiss();
                                    }
                                });
                    }
                }

            }
        });
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dial.dismiss();
            }
        });
		Engine.getMyFriend(getApplicationContext(), new RequestTemplate.ServiceCallback() {
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
						adap = new AddGroupAdapter(getApplicationContext(), p);
						listcontent.setAdapter(adap);
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}

			}
		});
		dial.show();
	}
}
