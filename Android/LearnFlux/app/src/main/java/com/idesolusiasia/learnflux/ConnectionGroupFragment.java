package com.idesolusiasia.learnflux;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.idesolusiasia.learnflux.adapter.ConnectionFragmentAdapter;
import com.idesolusiasia.learnflux.adapter.GroupOganizationAdapter;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Ide Solusi Asia on 10/4/2016.
 */

public class ConnectionGroupFragment  extends Fragment {
    GroupOganizationAdapter rcAdapter;
    RecyclerView recyclerView;
    Button seeHide;
    LinearLayout linearLayoutGroup;
    FrameLayout frameGroup;
    ArrayList<Group> arrOrg = new ArrayList<Group>();
    public static ConnectionGroupFragment newInstance() {
        ConnectionGroupFragment fragment = new ConnectionGroupFragment();
        return fragment;
    }

    public ConnectionGroupFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View v= inflater.inflate(R.layout.fragment_connectiongroup, container, false);
        seeHide = (Button)v.findViewById(R.id.seeHideButton);
        frameGroup = (FrameLayout)v.findViewById(R.id.frameLayoutGroup);
        seeHide.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                seeHide.setVisibility(View.GONE);
                frameGroup.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            }
        });
        recyclerView = (RecyclerView)v.findViewById(R.id.recyclerFragmentConnectionGroup);
        linearLayoutGroup = (LinearLayout)v.findViewById(R.id.linearConnectionGroup);
        frameGroup = (FrameLayout)v.findViewById(R.id.frameLayoutGroup);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext(), LinearLayoutManager.VERTICAL, false);
        recyclerView.setLayoutManager(linearLayoutManager);
        initOrganizations();
        return v;
    }
    void initOrganizations(){
        arrOrg = new ArrayList<>();
        Engine.getOrganizations(getContext(), new RequestTemplate.ServiceCallback() {
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
                        linearLayoutGroup.setVisibility(View.VISIBLE);
                    }else {
                        rcAdapter = new GroupOganizationAdapter(getContext(), arrOrg);
                        recyclerView.setAdapter(rcAdapter);
                        linearLayoutGroup.setVisibility(View.GONE);
                    }
                }catch (JSONException e){
                    e.printStackTrace();
                }

            }
        });
    }
}
