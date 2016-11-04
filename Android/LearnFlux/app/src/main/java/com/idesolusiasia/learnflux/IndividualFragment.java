package com.idesolusiasia.learnflux;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.idesolusiasia.learnflux.adapter.IndividualFragmentAdapter;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.util.ArrayList;

/**
 * Created by Ide Solusi Asia on 10/3/2016.
 */

public class IndividualFragment extends Fragment {
    IndividualFragmentAdapter Individualadap; ArrayList<Contact> ct= new ArrayList<Contact>();
    RecyclerView individualRecycler;
    TextView noData;
    public static IndividualFragment newInstance() {
        IndividualFragment fragment = new IndividualFragment();
        return fragment;
    }

    public IndividualFragment() {
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
        View v= inflater.inflate(R.layout.fragment_individual, container, false);
        //set recyclerView for Individual connection
        individualRecycler = (RecyclerView)v.findViewById(R.id.recyclerIndividual);
        noData = (TextView)v.findViewById(R.id.empty_view);
        LinearLayoutManager linearVerticalIndividual = new LinearLayoutManager(getContext(), LinearLayoutManager.VERTICAL,false);
        individualRecycler.setLayoutManager(linearVerticalIndividual);
        initIndividual();
        return v;
    }
    void initIndividual(){
        ct = new ArrayList<>();
        Engine.getMeWithRequest(getContext(),"friends", new RequestTemplate.ServiceCallback() {
            @Override
            public void execute(JSONObject obj) {
                try {
                    JSONArray friends = obj.getJSONArray("friends");
                    for (int i=0;i<friends.length();i++){
                        Contact c = Converter.convertContact(friends.getJSONObject(i));
                        ct.add(c);
                    }
                    if(ct.isEmpty()){
                        individualRecycler.setVisibility(View.GONE);
                        noData.setVisibility(View.VISIBLE);
                    }else {
                        individualRecycler.setVisibility(View.VISIBLE);
                        noData.setVisibility(View.GONE);
                        Individualadap = new IndividualFragmentAdapter(getContext(), ct);
                        individualRecycler.setAdapter(Individualadap);
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }
        });
    }
}
