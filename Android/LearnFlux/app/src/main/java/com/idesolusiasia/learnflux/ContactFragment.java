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

import com.idesolusiasia.learnflux.adapter.ContactAdapter;
import com.idesolusiasia.learnflux.entity.AllContact;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.viethoa.RecyclerViewFastScroller;
import com.viethoa.models.AlphabetItem;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
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
    void initFriend(){
        mAlphabetItems = new ArrayList<>();
        mDataArray = new ArrayList<>();
        mDataArray2 = new ArrayList<>();
        Engine.getMyFriend(getContext(), new RequestTemplate.ServiceCallback() {
            @Override
            public void execute(JSONObject obj) {
                try {
                    JSONArray data = obj.getJSONArray("data");
                    for(int i=0;i<data.length();i++){
                       final Participant participant = Converter.convertPeople(data.getJSONObject(i));
                       String firstname = participant.getFirstName();
                       mDataArray.add(firstname);
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }
        });
        Engine.getOrganizations(getContext(), new RequestTemplate.ServiceCallback() {
            @Override
            public void execute(JSONObject obj) {
                try {
                    JSONArray array = obj.getJSONArray("data");
                    for(int i=0;i<array.length();i++){
                        Group org = Converter.convertGroup(array.getJSONObject(i));
                        String name = org.getName();
                        mDataArray2.add(name);
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                mDataArray.addAll(mDataArray2);
                Collections.sort(mDataArray, String.CASE_INSENSITIVE_ORDER);
                for (int j = 0; j < mDataArray.size(); j++) {
                    String a = mDataArray.get(j);
                    if (a == null || a.trim().isEmpty())
                        continue;
                    String word = a.substring(0, 1);
                    if (!strAlphabets.contains(word)) {
                        strAlphabets.add(word);
                        mAlphabetItems.add(new AlphabetItem(j, word, false));
                    }
                }
                rcView.setAdapter(new ContactAdapter(mDataArray));
                //has to be called after recyclerview set adapter
                fastScroller.setRecyclerView(rcView);
                fastScroller.setUpAlphabet(mAlphabetItems);
            }

        });
    }

}

