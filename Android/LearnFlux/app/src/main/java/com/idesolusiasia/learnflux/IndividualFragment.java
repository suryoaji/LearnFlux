package com.idesolusiasia.learnflux;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
/**
 * Created by Ide Solusi Asia on 10/3/2016.
 */

public class IndividualFragment extends Fragment {
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
        return v;
    }
}
