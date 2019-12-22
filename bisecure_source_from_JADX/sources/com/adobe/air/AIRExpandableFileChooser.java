package com.adobe.air;

import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnKeyListener;
import android.content.res.Resources;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore.Audio.Media;
import android.provider.MediaStore.Images;
import android.provider.MediaStore.Video;
import android.util.SparseBooleanArray;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.BaseExpandableListAdapter;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.ExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.ExpandableListView.OnChildClickListener;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.adobe.air.utils.Utils;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AIRExpandableFileChooser implements OnChildClickListener {
    private static final String FILEINFO = "FILEINFO";
    public static final String TAG = AIRExpandableFileChooser.class.toString();
    private static final String TYPE = "TYPE";
    private static final String USER_ACTION_CANCEL = "cancel";
    private static final String USER_ACTION_DONE = "done";
    private ExpandableListAdapter mAdapter;
    private boolean mAllowMultiple = false;
    private SparseBooleanArray mCheckedFiles = new SparseBooleanArray();
    private List<List<Map<String, FileInfo>>> mChildData = new ArrayList();
    private AndroidAlertDialog mFileChooserDialog = null;
    private FileChooserStub mFileChooserStub = null;
    private final String[] mFileProjection = new String[]{"_data", "_display_name"};
    private EditText mFileSaveName = null;
    private ArrayList<String> mFilenames = new ArrayList();
    private List<Map<String, String>> mGroupData = new ArrayList();
    private View mMultipleFileSelectionView = null;
    private LayoutInflater mRuntimeInflater = null;
    private Resources mRuntimeResources = null;
    private boolean mSave = false;
    private String mSelection = new String();

    /* renamed from: com.adobe.air.AIRExpandableFileChooser$1 */
    class C00051 implements OnKeyListener {
        C00051() {
        }

        public boolean onKey(DialogInterface arg0, int arg1, KeyEvent event) {
            if (event.getKeyCode() == 4) {
                AIRExpandableFileChooser.this.mFileChooserStub.SetUserAction(AIRExpandableFileChooser.USER_ACTION_CANCEL);
            }
            return false;
        }
    }

    /* renamed from: com.adobe.air.AIRExpandableFileChooser$2 */
    class C00062 implements View.OnKeyListener {
        C00062() {
        }

        public boolean onKey(View v, int keyCode, KeyEvent event) {
            if (event.getAction() != 0 || keyCode != 66) {
                return false;
            }
            String filename = AIRExpandableFileChooser.this.mFileSaveName.getText().toString();
            if (filename.length() != 0) {
                AIRExpandableFileChooser.this.mFilenames.clear();
                AIRExpandableFileChooser.this.mFilenames.add(filename);
                AIRExpandableFileChooser.this.mFileChooserStub.SetUserAction(AIRExpandableFileChooser.USER_ACTION_DONE);
                AIRExpandableFileChooser.this.HideVirtualKeyboard(AIRExpandableFileChooser.this.mFileSaveName);
                AIRExpandableFileChooser.this.mFileChooserDialog.dismiss();
            }
            return true;
        }
    }

    /* renamed from: com.adobe.air.AIRExpandableFileChooser$3 */
    class C00073 implements OnClickListener {
        C00073() {
        }

        public void onClick(View view) {
            String filename = AIRExpandableFileChooser.this.mFileSaveName.getText().toString();
            if (filename.length() != 0) {
                AIRExpandableFileChooser.this.mFilenames.clear();
                AIRExpandableFileChooser.this.mFilenames.add(filename);
                AIRExpandableFileChooser.this.mFileChooserStub.SetUserAction(AIRExpandableFileChooser.USER_ACTION_DONE);
                AIRExpandableFileChooser.this.HideVirtualKeyboard(AIRExpandableFileChooser.this.mFileSaveName);
                AIRExpandableFileChooser.this.mFileChooserDialog.dismiss();
            }
        }
    }

    /* renamed from: com.adobe.air.AIRExpandableFileChooser$4 */
    class C00084 implements DialogInterface.OnClickListener {
        C00084() {
        }

        public void onClick(DialogInterface dialog, int whichButton) {
            AIRExpandableFileChooser.this.mFilenames.clear();
            int numGroups = AIRExpandableFileChooser.this.mGroupData.size();
            for (int i = 0; i < numGroups; i++) {
                int numChildren = ((List) AIRExpandableFileChooser.this.mChildData.get(i)).size();
                for (int j = 0; j < numChildren; j++) {
                    if (AIRExpandableFileChooser.this.mCheckedFiles.get(AIRExpandableFileChooser.this.expandableListPositionToFlatPosition(i, j))) {
                        AIRExpandableFileChooser.this.mFilenames.add(((FileInfo) ((HashMap) AIRExpandableFileChooser.this.mAdapter.getChild(i, j)).get(AIRExpandableFileChooser.FILEINFO)).mFilePath);
                    }
                }
            }
            AIRExpandableFileChooser.this.mFileChooserStub.SetUserAction(AIRExpandableFileChooser.USER_ACTION_DONE);
        }
    }

    /* renamed from: com.adobe.air.AIRExpandableFileChooser$5 */
    class C00095 implements DialogInterface.OnClickListener {
        C00095() {
        }

        public void onClick(DialogInterface dialog, int whichButton) {
            AIRExpandableFileChooser.this.uncheckAll();
            AIRExpandableFileChooser.this.mFileChooserStub.SetUserAction(AIRExpandableFileChooser.USER_ACTION_CANCEL);
        }
    }

    private class FileChooserExpandableListAdapter extends BaseExpandableListAdapter {
        private LayoutInflater mRuntimeInflater = null;
        private Resources mRuntimeResources = null;

        public FileChooserExpandableListAdapter(LayoutInflater runtimeInflater, Resources runtimeResources) {
            this.mRuntimeInflater = runtimeInflater;
            this.mRuntimeResources = runtimeResources;
        }

        public Object getChild(int groupPosition, int childPosition) {
            return ((List) AIRExpandableFileChooser.this.mChildData.get(groupPosition)).get(childPosition);
        }

        public long getChildId(int groupPosition, int childPosition) {
            return (long) childPosition;
        }

        public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
            FileChooserItem item;
            if (convertView == null || !(convertView instanceof FileChooserItem)) {
                item = new FileChooserItem(this.mRuntimeInflater, this.mRuntimeResources, parent, groupPosition, childPosition);
            } else {
                item = (FileChooserItem) convertView;
            }
            item.bindToData((FileInfo) ((Map) ((List) AIRExpandableFileChooser.this.mChildData.get(groupPosition)).get(childPosition)).get(AIRExpandableFileChooser.FILEINFO), groupPosition, childPosition);
            return item;
        }

        public int getChildrenCount(int groupPosition) {
            return ((List) AIRExpandableFileChooser.this.mChildData.get(groupPosition)).size();
        }

        public Object getGroup(int groupPosition) {
            return AIRExpandableFileChooser.this.mGroupData.get(groupPosition);
        }

        public int getGroupCount() {
            return AIRExpandableFileChooser.this.mGroupData.size();
        }

        public long getGroupId(int groupPosition) {
            return (long) groupPosition;
        }

        public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
            View v;
            if (convertView == null) {
                v = this.mRuntimeInflater.inflate(17367046, parent, false);
            } else {
                v = convertView;
            }
            TextView view = (TextView) v.findViewById(16908308);
            if (view != null) {
                view.setText((CharSequence) ((Map) AIRExpandableFileChooser.this.mGroupData.get(groupPosition)).get(AIRExpandableFileChooser.TYPE));
            }
            return v;
        }

        public boolean isChildSelectable(int groupPosition, int childPosition) {
            return true;
        }

        public boolean hasStableIds() {
            return true;
        }
    }

    private class FileChooserItem extends LinearLayout {
        private CompoundButton mFileCheckBox;
        private TextView mFileNameView;
        private TextView mFilePathView;
        private int mListFlatPosition = -1;
        private OnCheckedChangeListener mListener;

        FileChooserItem(LayoutInflater inflater, Resources runtimeResources, ViewGroup parent, int groupPosition, int childPosition) {
            super(AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity());
            View layoutView;
            if (AIRExpandableFileChooser.this.mAllowMultiple) {
                layoutView = Utils.GetLayoutView("expandable_multiple_chooser_row", runtimeResources, inflater);
                Resources layoutResources = layoutView.getResources();
                this.mFileNameView = (TextView) Utils.GetWidgetInViewByNameFromPackage("filename", layoutResources, layoutView);
                this.mFilePathView = (TextView) Utils.GetWidgetInViewByNameFromPackage("filepath", layoutResources, layoutView);
                this.mFileCheckBox = (CompoundButton) Utils.GetWidgetInViewByNameFromPackage("filecheck", layoutResources, layoutView);
                if (this.mFileNameView == null || this.mFilePathView == null || this.mFileCheckBox == null) {
                    this.mListFlatPosition = AIRExpandableFileChooser.this.expandableListPositionToFlatPosition(groupPosition, childPosition);
                    this.mListener = new OnCheckedChangeListener(AIRExpandableFileChooser.this) {
                        public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                            if (FileChooserItem.this.mListFlatPosition >= 0) {
                                if (isChecked) {
                                    AIRExpandableFileChooser.this.mCheckedFiles.put(FileChooserItem.this.mListFlatPosition, isChecked);
                                } else {
                                    AIRExpandableFileChooser.this.mCheckedFiles.delete(FileChooserItem.this.mListFlatPosition);
                                }
                            }
                        }
                    };
                    addView(layoutView);
                } else {
                    this.mListFlatPosition = AIRExpandableFileChooser.this.expandableListPositionToFlatPosition(groupPosition, childPosition);
                    this.mListener = /* anonymous class already generated */;
                    addView(layoutView);
                }
                return;
            }
            layoutView = Utils.GetLayoutView("expandable_chooser_row", runtimeResources, inflater);
            layoutResources = layoutView.getResources();
            this.mFileNameView = (TextView) Utils.GetWidgetInViewByNameFromPackage("filename", layoutResources, layoutView);
            this.mFilePathView = (TextView) Utils.GetWidgetInViewByNameFromPackage("filepath", layoutResources, layoutView);
            if (this.mFileNameView == null || this.mFilePathView == null) {
                addView(layoutView);
            } else {
                addView(layoutView);
            }
        }

        public void bindToData(FileInfo info, int groupPosition, int childPosition) {
            this.mFileNameView.setText(info.mFileName);
            this.mFilePathView.setText(info.mFilePath);
            if (AIRExpandableFileChooser.this.mAllowMultiple) {
                this.mListFlatPosition = AIRExpandableFileChooser.this.expandableListPositionToFlatPosition(groupPosition, childPosition);
                this.mFileCheckBox.setOnCheckedChangeListener(null);
                this.mFileCheckBox.setChecked(AIRExpandableFileChooser.this.mCheckedFiles.get(this.mListFlatPosition));
                this.mFileCheckBox.setOnCheckedChangeListener(this.mListener);
                info.mParent = this;
            }
        }

        public void toggle() {
            if (AIRExpandableFileChooser.this.mAllowMultiple) {
                this.mListener.onCheckedChanged(this.mFileCheckBox, !this.mFileCheckBox.isChecked());
                this.mFileCheckBox.setOnCheckedChangeListener(null);
                this.mFileCheckBox.setChecked(AIRExpandableFileChooser.this.mCheckedFiles.get(this.mListFlatPosition));
                this.mFileCheckBox.setOnCheckedChangeListener(this.mListener);
            }
        }

        public void uncheck() {
            if (AIRExpandableFileChooser.this.mAllowMultiple) {
                this.mListener.onCheckedChanged(this.mFileCheckBox, false);
                this.mFileCheckBox.setOnCheckedChangeListener(null);
                this.mFileCheckBox.setChecked(false);
                this.mFileCheckBox.setOnCheckedChangeListener(this.mListener);
            }
        }
    }

    private class FileInfo {
        public String mFileName = new String();
        public String mFilePath = new String();
        public FileChooserItem mParent = null;

        public FileInfo(String filename, String filepath) {
            this.mFileName = filename;
            this.mFilePath = filepath;
        }
    }

    public AIRExpandableFileChooser(ArrayList<String> filterList, boolean save, boolean allowMultiple, String defaultName, FileChooserStub chooserStub) {
        this.mSave = save;
        this.mAllowMultiple = allowMultiple;
        this.mFileChooserStub = chooserStub;
        if (filterList == null) {
            filterList = new ArrayList();
            filterList.add("*");
        }
        int count = filterList.size();
        for (int i = 0; i < count; i++) {
            String filterSpec = (String) filterList.get(i);
            if (filterSpec.startsWith("*")) {
                filterSpec = filterSpec.substring(1);
                if (filterSpec.length() == 0) {
                    break;
                }
            }
            if (this.mSelection.length() != 0) {
                this.mSelection += " OR ";
            }
            this.mSelection += "_display_name LIKE '%" + filterSpec + "'";
        }
        AndroidActivityWrapper activityWrapper = AndroidActivityWrapper.GetAndroidActivityWrapper();
        this.mFileChooserDialog = new AndroidAlertDialog(activityWrapper.getActivity());
        Builder dialogBuilder = this.mFileChooserDialog.GetAlertDialogBuilder();
        dialogBuilder.setOnKeyListener(new C00051());
        Context runtimeContext = activityWrapper.getRuntimeContext();
        this.mRuntimeInflater = activityWrapper.getActivity().getLayoutInflater();
        this.mRuntimeResources = activityWrapper.getActivity().getResources();
        View layoutView = Utils.GetLayoutView("main", this.mRuntimeResources, this.mRuntimeInflater);
        dialogBuilder.setView(layoutView);
        Resources layoutResources = layoutView.getResources();
        ExpandableListView list = (ExpandableListView) Utils.GetWidgetInView("list", layoutResources, layoutView);
        list.setOnChildClickListener(this);
        list.setEmptyView(activityWrapper.getActivity().findViewById(16908292));
        RelativeLayout fileSavePanel = (RelativeLayout) Utils.GetWidgetInViewByNameFromPackage("file_save_panel", layoutResources, layoutView);
        if (this.mSave) {
            dialogBuilder.setTitle(Utils.GetResourceString("file_download", this.mRuntimeResources));
            fileSavePanel.setVisibility(0);
            this.mFileSaveName = (EditText) Utils.GetWidgetInViewByNameFromPackage("file_save_name", layoutResources, layoutView);
            if (defaultName != null) {
                this.mFileSaveName.setText(Utils.GetExternalStorageDirectory() + "/" + defaultName);
            }
            this.mFileSaveName.setOnKeyListener(new C00062());
            ((Button) Utils.GetWidgetInViewByNameFromPackage("file_save_button", layoutResources, layoutView)).setOnClickListener(new C00073());
        } else {
            dialogBuilder.setTitle(Utils.GetResourceString("file_upload", this.mRuntimeResources));
            fileSavePanel.setVisibility(8);
        }
        AddMediaSubtree(Utils.GetResourceString("audio_files", this.mRuntimeResources), Media.EXTERNAL_CONTENT_URI);
        AddMediaSubtree(Utils.GetResourceString("image_files", this.mRuntimeResources), Images.Media.EXTERNAL_CONTENT_URI);
        AddMediaSubtree(Utils.GetResourceString("video_files", this.mRuntimeResources), Video.Media.EXTERNAL_CONTENT_URI);
        if (this.mGroupData.isEmpty()) {
            list.setVisibility(8);
        } else {
            this.mAdapter = new FileChooserExpandableListAdapter(this.mRuntimeInflater, this.mRuntimeResources);
            list.setAdapter(this.mAdapter);
            list.setItemsCanFocus(true);
            ((TextView) Utils.GetWidgetInViewByNameFromPackage("empty", layoutResources, layoutView)).setVisibility(8);
        }
        if (this.mAllowMultiple) {
            createInvisibleMultipleFileSelectionView();
        }
    }

    public boolean onChildClick(ExpandableListView parent, View view, int groupPosition, int childPosition, long id) {
        if (!(view instanceof FileChooserItem)) {
            return false;
        }
        FileChooserItem item = (FileChooserItem) view;
        if (this.mAllowMultiple) {
            item.toggle();
        } else {
            HashMap child = (HashMap) this.mAdapter.getChild(groupPosition, childPosition);
            if (this.mSave) {
                this.mFileSaveName.setText(((FileInfo) child.get(FILEINFO)).mFilePath);
            } else {
                this.mFilenames.clear();
                this.mFilenames.add(((FileInfo) child.get(FILEINFO)).mFilePath);
                this.mFileChooserStub.SetUserAction(USER_ACTION_DONE);
                this.mFileChooserDialog.dismiss();
            }
        }
        return true;
    }

    private int expandableListPositionToFlatPosition(int groupPosition, int childPosition) {
        if (groupPosition < 0 || groupPosition >= this.mChildData.size() || childPosition < 0 || childPosition >= ((List) this.mChildData.get(groupPosition)).size()) {
            return -1;
        }
        int flatPosition = 0;
        for (int i = 0; i < groupPosition; i++) {
            flatPosition += ((List) this.mChildData.get(i)).size();
        }
        return flatPosition + childPosition;
    }

    private void uncheckAll() {
        if (this.mAllowMultiple) {
            int numGroups = this.mGroupData.size();
            for (int i = 0; i < numGroups; i++) {
                int numChildren = ((List) this.mChildData.get(i)).size();
                for (int j = 0; j < numChildren; j++) {
                    FileChooserItem item = ((FileInfo) ((HashMap) this.mAdapter.getChild(i, j)).get(FILEINFO)).mParent;
                    if (item != null) {
                        item.uncheck();
                    }
                }
            }
        }
    }

    private void createInvisibleMultipleFileSelectionView() {
        Builder dialogBuilder = this.mFileChooserDialog.GetAlertDialogBuilder();
        dialogBuilder.setPositiveButton(Utils.GetResourceString("button_ok", this.mRuntimeResources), new C00084());
        dialogBuilder.setNegativeButton(Utils.GetResourceString("button_cancel", this.mRuntimeResources), new C00095());
    }

    private void AddMediaSubtree(String groupName, Uri groupUri) {
        Cursor childCursor = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().managedQuery(groupUri, this.mFileProjection, this.mSelection.length() == 0 ? null : this.mSelection, null, null);
        List<Map<String, FileInfo>> children = new ArrayList();
        if (childCursor != null && childCursor.moveToFirst()) {
            Map<String, String> groupMap = new HashMap();
            groupMap.put(TYPE, groupName);
            this.mGroupData.add(groupMap);
            do {
                FileInfo info = new FileInfo(childCursor.getString(childCursor.getColumnIndex("_display_name")), childCursor.getString(childCursor.getColumnIndex("_data")));
                Map<String, FileInfo> curChildMap = new HashMap();
                children.add(curChildMap);
                curChildMap.put(FILEINFO, info);
            } while (childCursor.moveToNext());
            this.mChildData.add(children);
        }
    }

    private void HideVirtualKeyboard(View view) {
        InputMethodManager imm = (InputMethodManager) view.getContext().getSystemService("input_method");
        if (imm != null) {
            imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
        }
    }

    public AndroidAlertDialog GetDialog() {
        return this.mFileChooserDialog;
    }

    public ArrayList<String> GetFileNames() {
        return this.mFilenames;
    }
}
