package com.idesolusiasia.learnflux;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.idesolusiasia.learnflux.adapter.AddGroupAdapter;
import com.idesolusiasia.learnflux.adapter.CreateGroupAdapter;
import com.idesolusiasia.learnflux.adapter.InterestGroupAdapter;
import com.idesolusiasia.learnflux.adapter.SearchAdapter;
import com.idesolusiasia.learnflux.adapter.SearchInterestGroup;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.FriendReq;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.ItemOffsetDecoration;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 8/15/2016.
 */
public class InterestGroup extends BaseActivity{
    ArrayList<Group> arrOrg = new ArrayList<Group>();
    public Participant participant=null;
    private GridLayoutManager lLayout;
    InterestGroupAdapter rcAdapter;
    ImageView add;
    TextView emptyView;
    RecyclerView recyclerView;
    AddGroupAdapter adap;
    public String name,desc;
    ListView listcontent;
    EditText searchBar;
    RecyclerView searchRecycler;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //setContentView(R.layout.activity_group_interest);
        setContentView(R.layout.activity_group_interest);
        super.onCreateDrawer(savedInstanceState);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        toolbar.setNavigationIcon(R.drawable.ic_arrow_back);

        recyclerView = (RecyclerView)findViewById(R.id.recycler_group_interest);
        final View includedLayout3 = (LinearLayout) findViewById(R.id.searchView);
        final View layout= (LinearLayout)findViewById(R.id.linearInterest);
        final ImageButton search = (ImageButton)findViewById(R.id.searchInterest);
        final ImageView enterSearh = (ImageView)findViewById(R.id.enterYourPreference);
        searchBar = (EditText)findViewById(R.id.searchID);
        final ImageView back = (ImageView)findViewById(R.id.imageBack);
        searchRecycler = (RecyclerView)findViewById(R.id.recyclerViewSearch);
        LinearLayoutManager linearManagerSearch = new LinearLayoutManager(getApplicationContext(), LinearLayoutManager.VERTICAL,false);
        searchRecycler.setLayoutManager(linearManagerSearch);
        emptyView = (TextView) findViewById(R.id.empty_view);
        add = (ImageView)findViewById(R.id.imageButtonAdd);
        add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                addInterestNewGroup();
            }
        });
        lLayout = new GridLayoutManager(getApplicationContext(),2);
        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(lLayout);
        search.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                includedLayout3.setVisibility(View.VISIBLE);
                layout.setVisibility(View.GONE);
                searchBar.addTextChangedListener(new TextWatcher() {
                    @Override
                    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                    }

                    @Override
                    public void onTextChanged(CharSequence s, int start, int before, int count) {
                            searching();
                    }

                    @Override
                    public void afterTextChanged(Editable s) {

                    }
                });
            }
        });
        initGroup();
    }
    private void searching(){
        arrOrg = new ArrayList<>();
        Engine.getSearchValue(getApplicationContext(), searchBar.getText().toString().trim(),
                new RequestTemplate.ServiceCallback() {
                    @Override
                    public void execute(JSONObject obj) {
                        try{
                            JSONArray group = obj.getJSONArray("groups");
                            if(group!=null){
                                for(int i=0;i<group.length();i++){
                                    Group g = Converter.convertGroup(group.getJSONObject(i));
                                    arrOrg.add(g);
                                }
                            }
                            SearchInterestGroup scg = new SearchInterestGroup(getApplicationContext(),arrOrg);
                            searchRecycler.setAdapter(scg);
                            searchRecycler.refreshDrawableState();



                        }catch (JSONException e){
                            e.printStackTrace();
                        }
                    }
                });
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
                    if(arrOrg.isEmpty()){
                        recyclerView.setVisibility(View.GONE);
                        emptyView.setVisibility(View.VISIBLE);
                    }else {
                        rcAdapter = new InterestGroupAdapter(InterestGroup.this, arrOrg);
                        recyclerView.setAdapter(rcAdapter);
                        emptyView.setVisibility(View.GONE);
                    }
                }catch (JSONException e){
                    e.printStackTrace();
                }

            }
        });
    }
 /*   @Override
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
    }*/
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
               // openRecycler();
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
                List<Integer> a = new ArrayList<>();
                for (FriendReq p : adap.getBox()) {
                    if (p.box) {
                        a.add(p.getId());
                    }
                }
                int[]ids = new int[a.size()];
                for(int i=0; i<a.size();i++){
                    ids[i]=a.get(i).intValue();
                }
                    Engine.createGroup(getApplicationContext(), ids, name, desc, null,
                            "group", new RequestTemplate.ServiceCallback() {
                                @Override
                                public void execute(JSONObject obj) {
                                    Toast.makeText(getApplicationContext(), "successfull", Toast.LENGTH_SHORT).show();
                                    dial.dismiss();
                                    finish();
                                    startActivity(getIntent());
                                }
                            });
            }
        });
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dial.dismiss();
            }
        });
        Engine.getMeWithRequest(getApplicationContext(),"friends", new RequestTemplate.ServiceCallback() {
            @Override
            public void execute(JSONObject obj) {
                try {
                    JSONArray array = obj.getJSONArray("friends");
                    ArrayList<FriendReq>contactReq = new ArrayList<>();
                    for(int i=0;i<array.length();i++){
                        JSONObject ap = array.getJSONObject(i);
                        FriendReq frQ = Converter.convertFriendRequest(ap);
                        contactReq.add(frQ);
                    }
                    if(contactReq.size()>0){
                        adap = new AddGroupAdapter(getApplicationContext(),contactReq);
                        listcontent.setAdapter(adap);
                    }else if(contactReq.size()==0){
                        Toast.makeText(getApplicationContext(),"You need to have friends", Toast.LENGTH_LONG).show();
                        finish();
                        Intent i = getIntent();
                        startActivity(i);
                    }
				} catch (JSONException e) {
					e.printStackTrace();
				}

			}
		});
		dial.show();
	}
/*    void openRecycler(){
        final Dialog dial = new Dialog(InterestGroup.this);
        dial.setTitle("Add participant");
        dial.setContentView(R.layout.activity_choosing_create_group);

        final RecyclerView createRecycler  = (RecyclerView) dial.findViewById(R.id.recycler_create);
        RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(dial.getContext(), LinearLayoutManager.VERTICAL,false);
        createRecycler.setLayoutManager(layoutManager);
        createRecycler.setItemAnimator(new DefaultItemAnimator());
        final ArrayList<FriendReq>friendList = new ArrayList<FriendReq>();
        Engine.getMeWithRequest(dial.getContext(), "friends", new RequestTemplate.ServiceCallback() {
            @Override
            public void execute(JSONObject obj) {
                 try{
                    JSONArray friend = obj.getJSONArray("friends");
                     for(int i=0;i<friend.length();i++){
                         JSONObject n = friend.getJSONObject(i);
                         FriendReq friends = Converter.convertFriendRequest(n);
                         friendList.add(friends);
                     }
                     CreateGroupAdapter cAdapter = new CreateGroupAdapter(dial.getContext(),friendList);
                     createRecycler.setAdapter(cAdapter);
                 }catch (JSONException e){
                     e.printStackTrace();
                 }
                    }
                });

    }*/
}
