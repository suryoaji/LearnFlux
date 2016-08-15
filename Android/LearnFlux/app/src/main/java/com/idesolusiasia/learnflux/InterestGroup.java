package com.idesolusiasia.learnflux;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.idesolusiasia.learnflux.adapter.OrganizationGridRecyclerViewAdapter;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
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
    private GridLayoutManager lLayout;
    OrganizationGridRecyclerViewAdapter rcAdapter;
    RecyclerView recyclerView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_group_interest);
        recyclerView = (RecyclerView)findViewById(R.id.recycler_group_interest);
        lLayout = new GridLayoutManager(getApplicationContext(),2);
        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(lLayout);
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
                    rcAdapter = new OrganizationGridRecyclerViewAdapter(getApplicationContext(),arrOrg);
                    recyclerView.setAdapter(rcAdapter);
                }catch (JSONException e){
                    e.printStackTrace();
                }

            }
        });
    }
}
