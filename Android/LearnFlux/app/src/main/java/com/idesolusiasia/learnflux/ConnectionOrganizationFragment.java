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

public class ConnectionOrganizationFragment extends Fragment {
    ConnectionFragmentAdapter rcAdapter;
    RecyclerView recyclerView;
    TextView emptyView;
    ArrayList<Group> arrOrg = new ArrayList<Group>();
    public static ConnectionOrganizationFragment newInstance() {
        ConnectionOrganizationFragment fragment = new ConnectionOrganizationFragment();
        return fragment;
    }

    public ConnectionOrganizationFragment() {
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
        View v= inflater.inflate(R.layout.fragment_connectionorg, container, false);
        recyclerView = (RecyclerView)v.findViewById(R.id.recyclerFragmentConnectionOrg);
        emptyView = (TextView)v.findViewById(R.id.empty_view);
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
                        if(array.getJSONObject(i).getString("type").equals("organization")) {
                            arrOrg.add(org);
                        }
                    }
                    if(arrOrg.isEmpty()){
                        recyclerView.setVisibility(View.GONE);
                        emptyView.setVisibility(View.VISIBLE);
                    }else {
                        rcAdapter = new ConnectionFragmentAdapter(getContext(), arrOrg);
                        recyclerView.setAdapter(rcAdapter);
                        emptyView.setVisibility(View.GONE);
                    }
                }catch (JSONException e){
                    e.printStackTrace();
                }

            }
        });
    }
}
