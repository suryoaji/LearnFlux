package com.idesolusiasia.learnflux;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.idesolusiasia.learnflux.adapter.SearchAdapter;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.viethoa.RecyclerViewFastScroller;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/17/2016.
 */

public class ContactFragment extends Fragment {
    RecyclerViewFastScroller fastScroller; RecyclerView rcView;
    TextView empty;
    private List<Object> theContact; SearchAdapter sc;
    public static ContactFragment newInstance() {
        ContactFragment fragment = new ContactFragment();
        return fragment;
    }
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View v= inflater.inflate(R.layout.contact_recyclerview_fastscroller, container, false);
        rcView = (RecyclerView)v.findViewById(R.id.my_recycler_view);
        empty = (TextView)v.findViewById(R.id.empty_contact);
        LinearLayoutManager linearVerticalIndividual = new LinearLayoutManager(getContext(), LinearLayoutManager.VERTICAL, false);
        rcView.setLayoutManager(linearVerticalIndividual);
        fastScroller = (RecyclerViewFastScroller)v.findViewById(R.id.fast_scroller);
        initFriend();
        return v;
    }
    public void initFriend(){
        theContact = new ArrayList<>();
        theContact.clear();
        Engine.getMeWithRequest(getContext(), "friends", new RequestTemplate.ServiceCallback() {
            @Override
            public void execute(JSONObject obj) {
                try {
                    JSONArray friends = obj.getJSONArray("friends");
                    for(int i=0;i<friends.length();i++) {
                        Contact c = Converter.convertContact(friends.getJSONObject(i));
                        theContact.add(c);

                        }
                    Engine.getOrganizations(getContext(), new RequestTemplate.ServiceCallback() {
                        @Override
                        public void execute(JSONObject obj) {
                            try {
                                JSONArray array = obj.getJSONArray("data");
                                for (int i = 0; i < array.length(); i++) {
                                    Group g = Converter.convertGroup(array.getJSONObject(i));
                                    theContact.add(g);
                                }
                                if(theContact.isEmpty()){
                                    empty.setVisibility(View.VISIBLE);
                                    rcView.setVisibility(View.GONE);
                                }else {
                                    empty.setVisibility(View.GONE);
                                    rcView.setVisibility(View.VISIBLE);
                                    Functions.sortingContact(theContact);
                                    bindDataToAdapter();
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }

                        }
                    });
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }
        });



    }
    private void bindDataToAdapter(){
        sc = new SearchAdapter(theContact);
        rcView.setAdapter(sc);
        rcView.refreshDrawableState();
    }

    @Override
    public void onResume() {
        super.onResume();
        if(sc !=null){
            sc.clearData();
        }
    }

}

