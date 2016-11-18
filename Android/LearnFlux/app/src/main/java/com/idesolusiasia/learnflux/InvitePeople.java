package com.idesolusiasia.learnflux;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.Toast;

import com.idesolusiasia.learnflux.adapter.CheckListPeopleAdapter;
import com.idesolusiasia.learnflux.entity.PeopleInvite;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 11/15/2016.
 */

public class InvitePeople extends BaseActivity{

    ArrayList<PeopleInvite> participant= new ArrayList<>();
    RecyclerView peopleRecycler;
    Button btnSelection;
    CheckListPeopleAdapter adaptPeople;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_base);
        super.onCreateDrawer(savedInstanceState);

        final FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
        final LayoutInflater layoutInflater = LayoutInflater.from(this);
        View childLayout = layoutInflater.inflate(
                R.layout.recycler_invite, null);
        parentLayout.addView(childLayout);

        final String ids = getIntent().getStringExtra("ids");
        btnSelection = (Button) findViewById(R.id.btnShow);
        peopleRecycler = (RecyclerView)findViewById(R.id.my_recycler_view);
        peopleRecycler.hasFixedSize();
        peopleRecycler.setLayoutManager(new LinearLayoutManager(this));

        Engine.getMeWithRequest(getApplicationContext(), "friends", new RequestTemplate.ServiceCallback() {
            @Override
            public void execute(JSONObject obj) {
                try{
                    if(obj.has("friends")){
                        JSONArray friend = obj.getJSONArray("friends");
                        for(int i=0;i<friend.length();i++) {
                            PeopleInvite people = Converter.convertInvite(friend.getJSONObject(i));
                            participant.add(people);
                        }
                        adaptPeople = new CheckListPeopleAdapter(getApplicationContext(),participant);
                        peopleRecycler.setAdapter(adaptPeople);

                    }
                }catch (JSONException e){
                    e.printStackTrace();
                }
            }
        });

        btnSelection.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String data = "";
                List<Integer> a = new ArrayList<>();
                List<PeopleInvite> stList = ((CheckListPeopleAdapter) adaptPeople)
                        .getInvitePeople();

                for (int i = 0; i < stList.size(); i++) {
                   PeopleInvite singleStudent = stList.get(i);
                    if (singleStudent.isSelected() == true) {
                        data = data + "\n" + singleStudent.getId();
                        a.add(singleStudent.getId());
                    }

                }
                int[]p = new int[a.size()];
                for(int b=0;b<a.size();b++){
                    p[b]=a.get(b).intValue();
                }
                Engine.putGroupByAdmin(getApplicationContext(), ids, p, new RequestTemplate.ServiceCallback() {
                    @Override
                    public void execute(JSONObject obj) {
                        Toast.makeText(getApplicationContext(),"successfull", Toast.LENGTH_LONG).show();
                        Intent i = new Intent(InvitePeople.this, ChatsActivity.class);
                        i.putExtra("chatroom", "org");
                        i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
                        i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                        startActivity(i);
                    }
                });

            }

        });
    }
}
