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

import com.google.gson.Gson;
import com.idesolusiasia.learnflux.adapter.ContactAdapter;
import com.idesolusiasia.learnflux.adapter.SearchAdapter;
import com.idesolusiasia.learnflux.entity.AllContact;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.viethoa.RecyclerViewFastScroller;
import com.viethoa.models.AlphabetItem;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/17/2016.
 */

public class ContactFragment extends Fragment {
    ContactAdapter contactAdapter;
    public List<String> strAlphabets = new ArrayList<>();
    RecyclerViewFastScroller fastScroller; RecyclerView rcView;
    public List<String> mDataArray;
    public List<String> mDataArray2;
    private List<AlphabetItem> mAlphabetItems;
    private List<Object> theContact;
    private List<Group> group;
    private List<Contact>coc;
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
        LinearLayoutManager linearVerticalIndividual = new LinearLayoutManager(getContext(), LinearLayoutManager.VERTICAL, false);
        rcView.setLayoutManager(linearVerticalIndividual);
        fastScroller = (RecyclerViewFastScroller)v.findViewById(R.id.fast_scroller);
        initFriend();
        return v;
    }
    public void initFriend(){
        mAlphabetItems = new ArrayList<>();
        mDataArray = new ArrayList<>();
        mDataArray2 = new ArrayList<>();
        theContact = new ArrayList<>();
        theContact.clear();
        coc = new ArrayList<>();
        group = new ArrayList<>();
        Engine.getMyFriend(getContext(), new RequestTemplate.ServiceCallback() {
            @Override
            public void execute(JSONObject obj) {
                try {
                    JSONArray data = obj.getJSONArray("data");
                    for(int i=0;i<data.length();i++){
                        Participant p = Converter.convertPeople(data.getJSONObject(i));
                        theContact.add(p);

                        Engine.getOrganizations(getContext(), new RequestTemplate.ServiceCallback() {
                            @Override
                            public void execute(JSONObject obj) {
                                try {
                                    JSONArray array = obj.getJSONArray("data");
                                    for (int i = 0; i < array.length(); i++) {
                                        Group g = Converter.convertGroup(array.getJSONObject(i));
                                        theContact.add(g);
                                    }
                                    Functions.sortingContact(theContact);
                                    bindDataToAdapter();
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }

                            }
                        });
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }
        });



    }
    private void bindDataToAdapter(){

        rcView.setAdapter(new SearchAdapter(theContact));
        rcView.refreshDrawableState();
    }


}

