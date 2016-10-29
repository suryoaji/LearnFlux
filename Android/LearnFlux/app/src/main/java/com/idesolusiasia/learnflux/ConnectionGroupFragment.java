package com.idesolusiasia.learnflux;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.idesolusiasia.learnflux.adapter.ConnectionFragmentAdapter;
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
    ConnectionFragmentAdapter rcAdapter;
    RecyclerView recyclerView;
    TextView empty;
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
        empty = (TextView)v.findViewById(R.id.empty_view);
        recyclerView = (RecyclerView)v.findViewById(R.id.recyclerFragmentConnectionOrg);
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
                        empty.setVisibility(View.VISIBLE);
                    }else {
                        rcAdapter = new ConnectionFragmentAdapter(getContext(), arrOrg);
                        recyclerView.setAdapter(rcAdapter);
                        empty.setVisibility(View.GONE);
                    }
                }catch (JSONException e){
                    e.printStackTrace();
                }

            }
        });
    }
}
