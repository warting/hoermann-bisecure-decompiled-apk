package com.adobe.air;

import java.util.Locale;

public class AndroidLocale {
    private static final String ANDROID_LOCALE_TAG = "AndroidLocale";
    private static final String LANG_ENGLISH = "en";
    private static final int MAX_LOCALE_NAME_SIZE = 10;

    public enum STRING_ID {
        IDA_CONTEXT_MENU_TITLE_STRING,
        IDA_CUT_ALL_STRING,
        IDA_CUT_STRING,
        IDA_PASTE_STRING,
        IDA_COPY_ALL_STRING,
        IDA_COPY_STRING,
        IDA_INPUT_METHOD_STRING,
        IDA_UPDATE,
        IDA_CANCEL,
        IDA_RUNTIME_UPDATE_MESSAGE,
        IDA_OK,
        IDA_DEBUGGER_ENTERIP_MESSAGE,
        IDA_DEBUGGER_ERROR_MESSAGE,
        IDA_CONTINUE,
        IDA_DEBUGGER_LISTEN_ERROR_TITLE,
        IDA_DEBUGGER_LISTEN_ERROR_MESSAGE,
        IDA_SELECT_TEXT,
        IDA_STOP_SELECTING_TEXT,
        IDA_SELECT_ALL
    }

    private static native String getLocalString(int i, String str);

    public static String GetLocalizedString(STRING_ID id) {
        return getLocalString(id.ordinal(), GetLocale());
    }

    public static String GetLocale() {
        String language = LANG_ENGLISH;
        Locale defaultLocale = Locale.getDefault();
        if (defaultLocale == null) {
            return language;
        }
        String lang = defaultLocale.getLanguage();
        if (lang == null) {
            return language;
        }
        if (!lang.equals("zh")) {
            return lang;
        }
        StringBuilder builder = new StringBuilder(MAX_LOCALE_NAME_SIZE);
        builder.append(lang);
        builder.append("_");
        builder.append(defaultLocale.getCountry());
        return builder.toString();
    }
}
