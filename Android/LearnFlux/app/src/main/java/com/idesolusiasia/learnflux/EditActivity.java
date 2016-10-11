package com.idesolusiasia.learnflux;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.idesolusiasia.learnflux.adapter.MyProfileAdapter;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Ide Solusi Asia on 10/10/2016.
 */

public class EditActivity extends AppCompatActivity {
    ImageView rightArrow;
    MyProfileAdapter rcAdapter;
    View included1, included2; TextView causes2;
    RecyclerView recyclerView; 	ArrayList<Group> arrOrg = new ArrayList<Group>();
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_profile);

        TextView causes  = (TextView) findViewById(R.id.causesOrganization);
        causes2 = (TextView) findViewById(R.id.causes2);
        rightArrow = (ImageView)findViewById(R.id.rightArrow1);
        included1 = (View)findViewById(R.id.included1);
        included2 = (View)findViewById(R.id.included2);
        recyclerView = (RecyclerView)findViewById(R.id.recyclee);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
        recyclerView.setLayoutManager(linearLayoutManager);
        causes.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                included1.setVisibility(View.VISIBLE);
                included1.bringToFront();
            }
        });
        causes2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                initOrganizations();
                included1.setVisibility(View.GONE);
                included2.setVisibility(View.VISIBLE);
                included2.bringToFront();
            }
        });

    }
    void initOrganizations(){
        arrOrg = new ArrayList<>();
        Engine.getOrganizations(getApplicationContext(), new RequestTemplate.ServiceCallback() {
            @Override
            public void execute(JSONObject obj) {
                try{
                    JSONArray array = obj.getJSONArray("data");
                    for(int i=0;i<array.length();i++){
                        Group org = Converter.convertOrganizations(array.getJSONObject(i));
                        if(array.getJSONObject(i).getString("type").equals("organization")) {
                            arrOrg.add(org);
                        }
                    }
                    if(arrOrg.isEmpty()){
                        recyclerView.setVisibility(View.GONE);
                        //emptyView.setVisibility(View.VISIBLE);
                    }else {
                        rcAdapter = new MyProfileAdapter(getApplicationContext(), arrOrg);
                        recyclerView.setAdapter(rcAdapter);
                        //emptyView.setVisibility(View.GONE);
                    }
                }catch (JSONException e){
                    e.printStackTrace();
                }

            }
        });
    }
}
