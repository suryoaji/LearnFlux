package com.idesolusiasia.learnflux;

import android.app.SearchManager;
import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.UriMatcher;
import android.database.Cursor;
import android.database.MatrixCursor;
import android.net.Uri;
import android.provider.BaseColumns;
import android.support.annotation.Nullable;
import android.util.Log;

import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.util.Engine;

import org.json.JSONArray;

import java.util.ArrayList;
import java.util.List;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

/**
 * Created by Ide Solusi Asia on 10/28/2016.
 */

public class UserSuggestionContentProvider extends ContentProvider {
    List<String> contact;
    private static final String AUTHORITY = "ngvl.android.demosearch.citysuggestion";

    private static final int TYPE_ALL_SUGGESTIONS = 1;
    private static final int TYPE_SINGLE_SUGGESTION = 2;

    private UriMatcher mUriMatcher;
    @Override
    public boolean onCreate() {
        mUriMatcher = new UriMatcher(UriMatcher.NO_MATCH);
        mUriMatcher.addURI(AUTHORITY, "/#", TYPE_SINGLE_SUGGESTION);
        mUriMatcher.addURI(AUTHORITY, "suggestions/search_suggest_query/*", TYPE_ALL_SUGGESTIONS);
        return false;
    }

    @Nullable
    @Override
    public Cursor query(Uri uri, String[] projection, String selection,
                        String[] selectionArgs, String sortOrder) {

        if(contact==null || contact.isEmpty()) {
            OkHttpClient client = new OkHttpClient();
            Request request = new Request.Builder()
                    .url("https://dl.dropboxusercontent.com/u/6802536/cidades.json")
                    .build();

            try {
                Response response = client.newCall(request).execute();
                String jsonString = response.body().string();
                JSONArray jsonArray = new JSONArray(jsonString);

                contact = new ArrayList<>();

                int lenght = jsonArray.length();
                for (int i = 0; i < lenght; i++) {
                    String city = jsonArray.getString(i);
                    contact.add(city);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }else {
        Log.d("NGVL", "Cache!");
    }

    MatrixCursor cursor = new MatrixCursor(
            new String[] {
                    BaseColumns._ID,
                    SearchManager.SUGGEST_COLUMN_TEXT_1,
                    SearchManager.SUGGEST_COLUMN_INTENT_DATA_ID
            }
    );

    if (mUriMatcher.match(uri) == TYPE_ALL_SUGGESTIONS) {
        if (contact != null) {
            String query = uri.getLastPathSegment().toUpperCase();
            int limit = Integer.parseInt(uri.getQueryParameter(SearchManager.SUGGEST_PARAMETER_LIMIT));

            int lenght = contact.size();
            for (int i = 0; i < lenght && cursor.getCount() < limit; i++) {
                String city = contact.get(i);
                if (city.toUpperCase().contains(query)) {
                    cursor.addRow(new Object[]{i, city, i});
                }
            }
        }
    } else if (mUriMatcher.match(uri) == TYPE_SINGLE_SUGGESTION) {
        int position = Integer.parseInt(uri.getLastPathSegment());
        String city = contact.get(position);
        cursor.addRow(new Object[]{position, city, position});
    }

        return cursor;

    }

    @Nullable
    @Override
    public String getType(Uri uri) {
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Nullable
    @Override
    public Uri insert(Uri uri, ContentValues contentValues) {
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public int delete(Uri uri, String s, String[] strings) {
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public int update(Uri uri, ContentValues contentValues, String s, String[] strings) {
        throw new UnsupportedOperationException("Not yet implemented");
    }
}
